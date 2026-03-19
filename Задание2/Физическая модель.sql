CREATE TABLE IF NOT EXISTS "Заказчик" (
    "id_заказчика"          VARCHAR(9) PRIMARY KEY,
    "наименование"          VARCHAR(255) NOT NULL,
    "ИНН"                   VARCHAR(12),
    "адрес"                 TEXT,
    "телефон"               VARCHAR(20),
    "является_поставщиком"  BOOLEAN DEFAULT false,
    "является_покупателем"  BOOLEAN DEFAULT false
);

CREATE TABLE IF NOT EXISTS "Справочник_Продукции" (
    "id_продукции"          SERIAL PRIMARY KEY,
    "наименование_продукции" VARCHAR(255) NOT NULL,
    "фасовка"               VARCHAR(50),
    "цена_реализации"       NUMERIC(10,2) NOT NULL
);

CREATE TABLE IF NOT EXISTS "Справочник_Материалов" (
    "id_материала"          SERIAL PRIMARY KEY,
    "наименование"          VARCHAR(255) NOT NULL,
    "единица_измерения"     VARCHAR(20),
    "цена_за_единицу"       NUMERIC(10,2) NOT NULL
);

CREATE TABLE IF NOT EXISTS "Спецификация" (
    "id_спецификации"       SERIAL PRIMARY KEY,
    "id_продукции"          INTEGER NOT NULL REFERENCES "Справочник_Продукции"("id_продукции"),
    "наименование_спецификации" VARCHAR(255),
    "дата_утверждения"      DATE
);

CREATE TABLE IF NOT EXISTS "Состав_Спецификации" (
    "id_записи"             SERIAL PRIMARY KEY,
    "id_спецификации"       INTEGER NOT NULL REFERENCES "Спецификация"("id_спецификации") ON DELETE CASCADE,
    "id_материала"          INTEGER NOT NULL REFERENCES "Справочник_Материалов"("id_материала"),
    "норма_расхода"         NUMERIC(10,4) NOT NULL
);

CREATE TABLE IF NOT EXISTS "Заказ" (
    "id_заказа"             SERIAL PRIMARY KEY,
    "дата_заказа"           DATE NOT NULL,
    "id_заказчика"          VARCHAR(9) NOT NULL REFERENCES "Заказчик"("id_заказчика"),
    "сумма_к_оплате"        NUMERIC(12,2),
    "статус"                VARCHAR(50) DEFAULT 'новый'
);

CREATE TABLE IF NOT EXISTS "Позиция_Заказа" (
    "id_позиции"            SERIAL PRIMARY KEY,
    "id_заказа"             INTEGER NOT NULL REFERENCES "Заказ"("id_заказа") ON DELETE CASCADE,
    "id_продукции"          INTEGER NOT NULL REFERENCES "Справочник_Продукции"("id_продукции"),
    "количество"            INTEGER NOT NULL CHECK ("количество" > 0),
    "цена_за_единицу"       NUMERIC(10,2) NOT NULL,
    "сумма_позиции"         NUMERIC(12,2) GENERATED ALWAYS AS ("количество" * "цена_за_единицу") STORED
);

INSERT INTO "Заказчик" ("id_заказчика", "наименование", "ИНН", "адрес", "телефон", "является_поставщиком", "является_покупателем")
VALUES
    ('000000001', 'ООО "Поставка"', '', 'г.Пятигорск', '+79198634592', true, true),
    ('000000002', 'ООО "Кинотеатр Квант"', '26320045123', 'г. Железноводск, ул. Мира, 123', '+79884581555', true, false),
    ('000000008', 'ООО "Новый JDTO"', '26320045111', 'г. Железноводсу', '+79884581555', true, false),
    ('000000003', 'ООО "Ромашка"', '4140784214', 'г. Омск, ул. Строителей, 294', '+79882584546', false, true),
    ('000000009', 'ООО "Ипподром"', '5874045632', 'г. Уфа, ул. Набережная, 37', '+79627486389', true, true),
    ('000000010', 'ООО "Ассоль"', '2629011278', 'г. Калуга, ул. Пушкина, 94', '+79184572398', false, true)
ON CONFLICT ("id_заказчика") DO NOTHING;
