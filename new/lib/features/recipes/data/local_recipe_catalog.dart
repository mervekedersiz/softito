import '../../../../core/models/enums.dart';
import '../domain/entities/recipe.dart';

class LocalRecipeCatalog {
  LocalRecipeCatalog._();

  static List<Recipe> get recipes => [
        Recipe(
          id: 'recipe_chicken_mushroom',
          name: 'Kremalı Mantarlı Tavuk Sote',
          cookingTimeMinutes: 20,
          servings: 2,
          difficulty: 'Hızlı Tava',
          subtitle: 'Tüm kiler hazır',
          rescuedDescription: '2 kritik malzeme kurtarılıyor',
          ingredients: const [
            RecipeIngredient(
              name: 'Tavuk Göğsü',
              amount: 450,
              unit: 'g',
              category: FoodCategory.meat,
            ),
            RecipeIngredient(
              name: 'Kültür Mantarı',
              amount: 250,
              unit: 'g',
              category: FoodCategory.produce,
            ),
            RecipeIngredient(
              name: 'Köy Sütü',
              amount: 150,
              unit: 'ml',
              category: FoodCategory.dairy,
            ),
            RecipeIngredient(
              name: 'Kaşar Peyniri',
              amount: 100,
              unit: 'g',
              category: FoodCategory.dairy,
              isOptional: true,
            ),
          ],
          instructions: const [
            'Tavukları küp doğrayıp yüksek ateşte zeytinyağında 5–6 dakika mühürleyin.',
            'Doğranmış mantarları ve ezilmiş sarımsağı ekleyip suyunu çekene kadar 6 dakika soteleyin.',
            'Dolaptaki köy sütünden 1 çay bardağı ve 1 tatlı kaşığı un (veya krema) ekleyip kıvam alınca ocaktan alın.',
          ],
        ),
        Recipe(
          id: 'recipe_baked_mushroom_pasta',
          name: 'Kremalı Mantarlı Fırın Makarna',
          cookingTimeMinutes: 25,
          servings: 2,
          difficulty: 'Kolay Seviye',
          subtitle: 'Tüm malzemeler rafta',
          rescuedDescription: '3 malzeme israftan kurtarılıyor',
          ingredients: const [
            RecipeIngredient(
              name: 'Burgu Makarna',
              amount: 250,
              unit: 'g',
              category: FoodCategory.pantry,
            ),
            RecipeIngredient(
              name: 'Kültür Mantarı',
              amount: 200,
              unit: 'g',
              category: FoodCategory.produce,
            ),
            RecipeIngredient(
              name: 'Organik Köy Sütü',
              amount: 200,
              unit: 'ml',
              category: FoodCategory.dairy,
            ),
            RecipeIngredient(
              name: 'Taze Kaşar Peyniri',
              amount: 150,
              unit: 'g',
              category: FoodCategory.dairy,
            ),
          ],
          instructions: const [
            'Makarnayı bol tuzlu suda 8 dakika haşlayıp süzün.',
            'Mantarları hafif soteleyin, süt ve kaşar peynirinin yarısını ekleyip sos hazırlayın.',
            'Makarnayı sosla harmanlayıp fırın kabına alın, kalan kaşarı üzerine serpip 180°C fırında 15 dakika kızartın.',
          ],
        ),
        Recipe(
          id: 'recipe_baked_veggies',
          name: 'Fırında Kaşarlı Sebze Graten',
          cookingTimeMinutes: 30,
          servings: 3,
          difficulty: 'Orta Seviye',
          subtitle: '1 Eksik Malzeme',
          rescuedDescription: '2 malzeme israftan kurtarılıyor',
          ingredients: const [
            RecipeIngredient(
              name: 'Havuç',
              amount: 250,
              unit: 'g',
              category: FoodCategory.produce,
            ),
            RecipeIngredient(
              name: 'Dondurulmuş Bezelye',
              amount: 200,
              unit: 'g',
              category: FoodCategory.produce,
            ),
            RecipeIngredient(
              name: 'Taze Kaşar Peyniri',
              amount: 200,
              unit: 'g',
              category: FoodCategory.dairy,
            ),
            RecipeIngredient(
              name: 'Sıvı Krema',
              amount: 200,
              unit: 'ml',
              category: FoodCategory.dairy,
            ),
          ],
          instructions: const [
            'Havuç ve bezelyeleri 5 dakika buharda haşlayın.',
            'Fırın kabına sebzeleri yayın, üzerine krema ve baharatları dökün.',
            'Bol kaşar peyniri rendeleyerek fırında 20 dakika üzeri nar gibi kızarana kadar pişirin.',
          ],
        ),
        Recipe(
          id: 'recipe_lentil_soup',
          name: 'Geleneksel Kırmızı Mercimek Çorbası',
          cookingTimeMinutes: 25,
          servings: 4,
          difficulty: 'Kolay Seviye',
          subtitle: 'Kiler Dostu',
          rescuedDescription: 'Bakliyat stoklarını değerlendirin',
          ingredients: const [
            RecipeIngredient(
              name: 'Kırmızı Mercimek',
              amount: 250,
              unit: 'g',
              category: FoodCategory.pantry,
            ),
            RecipeIngredient(
              name: 'Havuç',
              amount: 100,
              unit: 'g',
              category: FoodCategory.produce,
            ),
            RecipeIngredient(
              name: 'Köy Tereyağı',
              amount: 30,
              unit: 'g',
              category: FoodCategory.dairy,
            ),
            RecipeIngredient(
              name: 'Limon',
              amount: 1,
              unit: 'adet',
              category: FoodCategory.produce,
            ),
          ],
          instructions: const [
            'Tereyağında doğranmış havuç ve mercimeği 2 dakika kavurun.',
            'Sıcak su ekleyip mercimekler yumuşayana kadar 20 dakika kaynatın.',
            'Pürüzsüz kıvam için blenderdan geçirin, taze limon suyuyla servis edin.',
          ],
        ),
      ];
}
