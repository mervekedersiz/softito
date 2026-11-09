import os
import time
from typing import List, Optional
from fastapi import FastAPI, HTTPException, Request, status
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field

app = FastAPI(
    title="FreshTrack Chef AI Backend",
    description="Stateless Chef AI assistant proxy for recipe matching and food preservation.",
    version="1.0.0",
)

# Enable CORS for Flutter web and local clients
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Rate limiting tracker (in-memory sliding window by IP)
_RATE_LIMIT_WINDOW = 60  # seconds
_MAX_REQUESTS_PER_WINDOW = 30
_client_requests = {}


class InventoryItemSummary(BaseModel):
    name: str = Field(..., min_length=1, max_length=100)
    category: str = Field(..., max_length=50)
    days_left: int
    quantity: float
    unit: str


class ChefRequest(BaseModel):
    query: str = Field(..., min_length=2, max_length=500)
    inventory: List[InventoryItemSummary] = Field(default_factory=list)


class ChefResponse(BaseModel):
    reply: str
    suggested_action: Optional[str] = None
    matched_recipe_id: Optional[str] = None
    disclaimer: str = (
        "Gıda Güvenliği: Öneriler bilgilendirme amaçlıdır. "
        "Tarihi geçmiş veya şüpheli kokan gıdaları tüketmeyiniz."
    )


@app.middleware("http")
async def rate_limit_middleware(request: Request, call_next):
    client_ip = request.client.host if request.client else "127.0.0.1"
    now = time.time()

    # Clean old requests
    timestamps = _client_requests.get(client_ip, [])
    timestamps = [t for t in timestamps if now - t < _RATE_LIMIT_WINDOW]

    if len(timestamps) >= _MAX_REQUESTS_PER_WINDOW:
        raise HTTPException(
            status_code=status.HTTP_429_TOO_MANY_REQUESTS,
            detail="Çok fazla istek gönderildi. Lütfen bir dakika sonra tekrar deneyin.",
        )

    timestamps.append(now)
    _client_requests[client_ip] = timestamps

    response = await call_next(request)
    return response


@app.get("/health")
def health_check():
    return {
        "status": "ok",
        "service": "freshtrack-chef-backend",
        "has_external_llm": bool(
            os.getenv("OPENAI_API_KEY") or os.getenv("GEMINI_API_KEY")
        ),
    }


@app.post("/v1/chef/respond", response_model=ChefResponse)
def respond_chef(req: ChefRequest):
    q = req.query.strip().lower()

    # Check for expired items in inventory
    expired_items = [i for i in req.inventory if i.days_left < 0]
    critical_items = [i for i in req.inventory if 0 <= i.days_left <= 2]

    # Rule-based food intelligence engine (stateless, privacy-preserving)
    if "tavuk" in q and "marine" in q:
        reply = (
            "Tavuk göğsünü sulu ve yumuşak tutmak için zeytinyağı, ezilmiş sarımsak, "
            "1 tatlı kaşığı yoğurt ve kekikle en az 20 dakika dinlendirebilirsiniz."
        )
        return ChefResponse(
            reply=reply,
            suggested_action="Tarifi Gör & Malzemeleri Düş",
            matched_recipe_id="recipe_chicken_mushroom",
        )

    elif "mantar" in q and "tavuk" in q:
        reply = (
            "Dolabınızdaki tavuk göğsü ve mantarla 20 dakikada 'Kremalı Mantarlı Tavuk Sote' "
            "hazırlayabilirsiniz. 2 kritik stok malzemeniz başarıyla kurtarılacaktır."
        )
        return ChefResponse(
            reply=reply,
            suggested_action="Bugün Pişir'e Ekle",
            matched_recipe_id="recipe_chicken_mushroom",
        )

    elif "pişir" in q or "ne yap" in q or "yemek" in q:
        if critical_items:
            names = ", ".join([f"{item.name} ({item.days_left} gün)" for item in critical_items[:2]])
            reply = (
                f"Envanterinizde öncelikli tüketilmesi gereken {names} var. "
                "Bunlarla 'Kremalı Mantarlı Tavuk Sote' veya fırında sebze hazırlayabilirsiniz."
            )
        else:
            reply = (
                "Aktif stoklarınız güvenli durumda. Kilerinizdeki mercimek veya makarna ile "
                "lezzetli ve dengeli bir öğün planlayabilirsiniz."
            )
        return ChefResponse(
            reply=reply,
            suggested_action="Tarif Kataloğunu İncele",
            matched_recipe_id="recipe_chicken_mushroom",
        )

    elif "bağış" in q or "paylaş" in q or "yardım" in q:
        reply = (
            "İhtiyaç fazlası kapalı ambalajlı bakliyat ve kuru gıdalarınızı "
            "Gıda Bağışı & Paylaşım ekranından erzak paketlerine ekleyerek "
            "Kadıköy Aşevi ve mahalle dayanışma dolaplarına ulaştırabilirsiniz."
        )
        return ChefResponse(reply=reply, suggested_action="Bağış Ekranına Git")

    elif "sakla" in q or "bozul" in q:
        reply = (
            "Açılmış süt ürünlerini hava almayan cam kapta buzdolabının üst rafında (4°C) saklayın. "
            "Et ürünlerini 1 gün içinde pişirmeyecekseniz porsiyonlayıp dondurucuya (-18°C) kaldırınız."
        )
        return ChefResponse(reply=reply)

    else:
        crit_msg = ""
        if critical_items:
            crit_msg = f" Özellikle dolaptaki {critical_items[0].name} için tüketim zamanı yaklaşıyor."
        reply = (
            f"Sorunuzu değerlendirdim.{crit_msg} "
            "Mutfakta israfı önlemek için son kullanma tarihi en yakın ürünleri önceliklendirmenizi öneririm."
        )
        return ChefResponse(reply=reply)
