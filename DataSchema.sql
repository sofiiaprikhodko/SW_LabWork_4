-- ===== Таблиця БезпечнеСередовище =====
CREATE TABLE SafeEnvironment (
    sec_id INTEGER PRIMARY KEY,
    security_level VARCHAR(30) NOT NULL CHECK (security_level IN ('Базовий', 'Розширений', 'Максимальний')),
    correctness_check BOOLEAN NOT NULL DEFAULT TRUE,
    auto_save BOOLEAN NOT NULL DEFAULT TRUE
);

-- ===== Таблиця Користувач =====
CREATE TABLE User (
    user_id INTEGER PRIMARY KEY,
    sec_id INTEGER NOT NULL,
    name VARCHAR(50) NOT NULL CHECK (name ~ '^[A-ЯІЇЄҐA-Za-z]{2,50}$'),
    age INTEGER NOT NULL CHECK (age > 0),
    workload VARCHAR(30) NOT NULL CHECK (workload IN ('Низьке', 'Середнє', 'Високе')),
    working_hours INTEGER CHECK (working_hours >= 0),
    level_of_experience VARCHAR(30) DEFAULT 'Початківець' CHECK (level_of_experience IN ('Початківець','Середній','Експерт')),
    CONSTRAINT fk_user_security FOREIGN KEY (sec_id) REFERENCES SafeEnvironment(sec_id)
);

-- ===== Таблиця Скульптура =====
CREATE TABLE Sculpture (
    sculpture_id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    sec_id INTEGER NOT NULL,
    name VARCHAR(100) NOT NULL CHECK (name ~ '^[A-Za-zА-Яа-я0-9\s-]{2,100}$'),
    material VARCHAR(50) CHECK (material IN ('Глина','Гіпс','Камінь','Метал')),
    size VARCHAR(30) CHECK (size IN ('Малий','Середній','Великий')),
    creation_date DATE NOT NULL,
    CONSTRAINT fk_sculpture_user FOREIGN KEY (user_id) REFERENCES User(user_id),
    CONSTRAINT fk_sculpture_security FOREIGN KEY (sec_id) REFERENCES SafeEnvironment(sec_id)
);

-- ===== Таблиця ІнструментРедагування =====
CREATE TABLE EditingTool (
    tool_id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    sculpture_id INTEGER NOT NULL,
    name VARCHAR(50) NOT NULL,
    type VARCHAR(30) NOT NULL CHECK (type IN ('Моделювання','Згладжування','Обрізка','Текстурування')),
    CONSTRAINT fk_tool_user FOREIGN KEY (user_id) REFERENCES User(user_id),
    CONSTRAINT fk_tool_sculpture FOREIGN KEY (sculpture_id) REFERENCES Sculpture(sculpture_id)
);

-- ===== Таблиця БазаЗнань =====
CREATE TABLE KnowledgeBase (
    base_id INTEGER PRIMARY KEY,
    information_resources TEXT NOT NULL,
    relevance DATE
);

-- ===== Таблиця Рекомендація =====
CREATE TABLE Recommendation (
    rec_id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    base_id INTEGER NOT NULL,
    type VARCHAR(30) NOT NULL CHECK (type IN ('Харчування','Режим праці')),
    description TEXT NOT NULL,
    date_of_creation DATE NOT NULL,
    CONSTRAINT fk_rec_user FOREIGN KEY (user_id) REFERENCES User(user_id),
    CONSTRAINT fk_rec_base FOREIGN KEY (base_id) REFERENCES KnowledgeBase(base_id)
);

-- ===== Таблиця РекомендаціяХарчування =====
CREATE TABLE MealRecommendation (
    rec_id INTEGER PRIMARY KEY,
    meal_time TIME NOT NULL,
    meal_type VARCHAR(30) NOT NULL CHECK (meal_type IN ('Сніданок','Обід','Вечеря','Перекус')),
    calories INTEGER CHECK (calories > 0),
    CONSTRAINT fk_recfood_rec FOREIGN KEY (rec_id) REFERENCES Recommendation(rec_id)
);

-- ===== Таблиця РекомендаціяРежиму =====
CREATE TABLE ModeRecommendation (
    rec_id INTEGER PRIMARY KEY,
    start_time TIME NOT NULL,
    duration INTEGER NOT NULL CHECK (duration > 0),
    break_time INTEGER NOT NULL CHECK (break_time >= 0),
    CONSTRAINT fk_recmode_rec FOREIGN KEY (rec_id) REFERENCES Recommendation(rec_id)
);
