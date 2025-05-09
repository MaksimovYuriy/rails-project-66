### Hexlet tests and linter status:
[![Actions Status](https://github.com/MaksimovYuriy/rails-project-66/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/MaksimovYuriy/rails-project-66/actions)

### Custom tests and linter status:
[![Actions Status](https://github.com/MaksimovYuriy/rails-project-66/actions/workflows/ci.yml/badge.svg)](https://github.com/MaksimovYuriy/rails-project-66/actions)

Продакшен: 
https://repositoryquality.onrender.com

# Оценка качества репозиториев

## Стек технологий
- Ruby on Rails
- SQLite3, PostgreSQL
- Sentry, Github

## Описание
Проект помогает отследить ошибки в стиле кода и дать оценку текущему состоянию

## Функционал
- Авторизация через GitHub
- Добавление своего репозитория из GitHub на платформу
- Прогон линтера на проекте (Rubocop, ESLint)

## Установка

1. Клонируйте репозиторий:
   ```bash
   git clone https://github.com/MaksimovYuriy/rails-project-66
   cd rails-project-66

2. Выполните базовую настройку проекта:
    ```bash
    make setup

3. Сгенерируйте файл окружения и заполните его:
    ```bash
    make env

4. Запустите проект:
    ```bash
    rails server