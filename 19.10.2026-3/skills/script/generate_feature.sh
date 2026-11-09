#!/usr/bin/env bash

# ==============================================================================
# generate_feature.sh
# 
# Flutter Feature-Driven Mimari İskelet Üretici
# Kurallar:
#   1. Clean UI & Reaktif State (ValueNotifier)
#   2. Asla tek dosyada toplama (controllers, models, views, widgets)
#   3. Const zorunluluğu ve 40 satır altı build metotları
# ==============================================================================

set -e

# Renk tanımları
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Yardım mesajı
usage() {
    echo -e "${CYAN}Kullanım:${NC} $0 <feature_name> [hedef_dizin]"
    echo -e "  ${YELLOW}Örnek:${NC} $0 water_tracker"
    echo -e "  ${YELLOW}Örnek:${NC} $0 workout_plan ./lib"
    exit 1
}

# Parametre kontrolü
if [ -z "$1" ]; then
    echo -e "${RED}Hata:${NC} Bir feature ismi belirtmelisiniz!"
    usage
fi

RAW_NAME="$1"
# Küçük harfe ve geçerli snake_case formatına çevir
FEATURE_NAME=$(echo "$RAW_NAME" | tr '[:upper:]' '[:lower:]' | tr '-' '_')
TARGET_BASE="${2:-lib}"

# PascalCase ve camelCase dönüşümleri
# Örnek: water_tracker -> WaterTracker ve waterTracker
PASCAL_CASE=$(echo "$FEATURE_NAME" | awk -F '_' '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1' OFS='')
CAMEL_CASE="$(tr '[:upper:]' '[:lower:]' <<< "${PASCAL_CASE:0:1}")${PASCAL_CASE:1}"

echo -e "${CYAN}======================================================${NC}"
echo -e "${GREEN}🚀 Feature İskeleti Oluşturuluyor: ${PASCAL_CASE}${NC} (${FEATURE_NAME})"
echo -e "${CYAN}======================================================${NC}"

FEATURE_DIR="${TARGET_BASE}/features/${FEATURE_NAME}"
CONTROLLERS_DIR="${FEATURE_DIR}/controllers"
MODELS_DIR="${FEATURE_DIR}/models"
VIEWS_DIR="${FEATURE_DIR}/views"
WIDGETS_DIR="${FEATURE_DIR}/widgets"

# Dizinleri oluştur
mkdir -p "$CONTROLLERS_DIR" "$MODELS_DIR" "$VIEWS_DIR" "$WIDGETS_DIR"
echo -e "${YELLOW}📁 Klasörler hazırlandı:${NC} $FEATURE_DIR"

# 1. MODEL DOSYASI
MODEL_FILE="${MODELS_DIR}/${FEATURE_NAME}_model.dart"
if [ ! -f "$MODEL_FILE" ]; then
cat <<EOF > "$MODEL_FILE"
class ${PASCAL_CASE}Model {
  final String id;
  final String title;
  final int value;
  final bool isCompleted;
  final DateTime lastUpdated;

  const ${PASCAL_CASE}Model({
    required this.id,
    required this.title,
    required this.value,
    required this.isCompleted,
    required this.lastUpdated,
  });

  ${PASCAL_CASE}Model copyWith({
    String? id,
    String? title,
    int? value,
    bool? isCompleted,
    DateTime? lastUpdated,
  }) {
    return ${PASCAL_CASE}Model(
      id: id ?? this.id,
      title: title ?? this.title,
      value: value ?? this.value,
      isCompleted: isCompleted ?? this.isCompleted,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  factory ${PASCAL_CASE}Model.fromJson(Map<String, dynamic> json) {
    return ${PASCAL_CASE}Model(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      value: (json['value'] as num?)?.toInt() ?? 0,
      isCompleted: json['isCompleted'] as bool? ?? false,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.tryParse(json['lastUpdated'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'value': value,
      'isCompleted': isCompleted,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}
EOF
echo -e "  ${GREEN}✔ Model oluşturuldu:${NC} $MODEL_FILE"
else
echo -e "  ${YELLOW}⚠ Model zaten var, atlandı:${NC} $MODEL_FILE"
fi

# 2. CONTROLLER DOSYASI
CONTROLLER_FILE="${CONTROLLERS_DIR}/${FEATURE_NAME}_controller.dart"
if [ ! -f "$CONTROLLER_FILE" ]; then
cat <<EOF > "$CONTROLLER_FILE"
import 'package:flutter/foundation.dart';
import '../models/${FEATURE_NAME}_model.dart';

class ${PASCAL_CASE}Controller {
  final ValueNotifier<${PASCAL_CASE}Model> state =
      ValueNotifier<${PASCAL_CASE}Model>(
    ${PASCAL_CASE}Model(
      id: 'default_id',
      title: '${PASCAL_CASE}',
      value: 0,
      isCompleted: false,
      lastUpdated: DateTime.now(),
    ),
  );

  ${PASCAL_CASE}Model get current => state.value;

  void increment() {
    state.value = current.copyWith(
      value: current.value + 1,
      lastUpdated: DateTime.now(),
    );
  }

  void toggleStatus() {
    state.value = current.copyWith(
      isCompleted: !current.isCompleted,
      lastUpdated: DateTime.now(),
    );
  }

  void reset() {
    state.value = current.copyWith(
      value: 0,
      isCompleted: false,
      lastUpdated: DateTime.now(),
    );
  }

  void dispose() {
    state.dispose();
  }
}
EOF
echo -e "  ${GREEN}✔ Controller oluşturuldu:${NC} $CONTROLLER_FILE"
else
echo -e "  ${YELLOW}⚠ Controller zaten var, atlandı:${NC} $CONTROLLER_FILE"
fi

# 3. WIDGET DOSYASI
WIDGET_FILE="${WIDGETS_DIR}/${FEATURE_NAME}_card.dart"
if [ ! -f "$WIDGET_FILE" ]; then
cat <<EOF > "$WIDGET_FILE"
import 'package:flutter/material.dart';
import '../models/${FEATURE_NAME}_model.dart';

class ${PASCAL_CASE}Card extends StatelessWidget {
  final ${PASCAL_CASE}Model model;
  final VoidCallback? onIncrement;
  final VoidCallback? onToggle;

  const ${PASCAL_CASE}Card({
    super.key,
    required this.model,
    this.onIncrement,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 12),
            _buildContent(context),
            const SizedBox(height: 12),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          model.title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Icon(
          model.isCompleted
              ? Icons.check_circle_rounded
              : Icons.radio_button_unchecked_rounded,
          color: model.isCompleted ? Colors.green : Colors.grey,
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Text(
      'Mevcut Değer: \${model.value}',
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (onToggle != null)
          TextButton(
            onPressed: onToggle,
            child: Text(model.isCompleted ? 'Geri Al' : 'Tamamla'),
          ),
        const SizedBox(width: 8),
        if (onIncrement != null)
          ElevatedButton.icon(
            onPressed: onIncrement,
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Artır'),
          ),
      ],
    );
  }
}
EOF
echo -e "  ${GREEN}✔ Widget oluşturuldu:${NC} $WIDGET_FILE"
else
echo -e "  ${YELLOW}⚠ Widget zaten var, atlandı:${NC} $WIDGET_FILE"
fi

# 4. VIEW DOSYASI
VIEW_FILE="${VIEWS_DIR}/${FEATURE_NAME}_view.dart"
if [ ! -f "$VIEW_FILE" ]; then
cat <<EOF > "$VIEW_FILE"
import 'package:flutter/material.dart';
import '../controllers/${FEATURE_NAME}_controller.dart';
import '../models/${FEATURE_NAME}_model.dart';
import '../widgets/${FEATURE_NAME}_card.dart';

class ${PASCAL_CASE}View extends StatelessWidget {
  final ${PASCAL_CASE}Controller controller;

  const ${PASCAL_CASE}View({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('${PASCAL_CASE} Modülü'),
        actions: [
          IconButton(
            tooltip: 'Sıfırla',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: controller.reset,
          ),
        ],
      ),
      body: ValueListenableBuilder<${PASCAL_CASE}Model>(
        valueListenable: controller.state,
        builder: (context, model, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ${PASCAL_CASE}Card(
                  model: model,
                  onIncrement: controller.increment,
                  onToggle: controller.toggleStatus,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
EOF
echo -e "  ${GREEN}✔ View oluşturuldu:${NC} $VIEW_FILE"
else
echo -e "  ${YELLOW}⚠ View zaten var, atlandı:${NC} $VIEW_FILE"
fi

echo -e "\n${GREEN}✨ Başarıyla tamamlandı!${NC}"
echo -e "${CYAN}Doğrulama Adımları:${NC}"
echo -e "  1. flutter analyze"
echo -e "  2. flutter test"
