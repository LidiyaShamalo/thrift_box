# ThriftBox

## 1. Создание проекта

```bash
 mix phx.new - -binary-id name_project
```

Флаг --binary-id используется для того, чтобы во всем проекте в качестве первичных ключей (Primary Keys) в базе данных использовались UUID (уникальные идентификаторы), а не стандартные автоинкрементные целые числа (integers).

## 2. Установка зависимостей

```bash
mix setup
```

Команда подготовила проект, а имеено:

- Скачала зависимости (mix deps.get).
- Создала базу данных и запустила миграции (mix ecto.setup).
- Скомпилировала активы (Tailwind, JS).
Если перейти на localhost4000/dev/dashboard/home - можно увидеть производительность. Работатет только в среде разработки.

### Проверка зависимостей

```bash
mix hex.outdated
```

### Обновление зависимостей

```bash
mix deps.update --all
```

## 3. Запуск сервера

```bash
mix phx.server
```

## 4. Генерация аутентификации для пользователей

```bash
mix phx.gen.auth Accounts User users --hashing-lib argon2
#                ^^^^^^   ^^^  ^^^         ^^^^^^^^^^^^
#                contex  schema table DB     безопасность
```

**Генерирует:**

1. **Data Model**:
    * User
        * email,
        * hashed password,
        *confirmed at;
    * Token:
        * token(hash value),
        * context(session, reset, password, confirm),
        * sent to;

2. **Capabilities(возможности)**:

    * Registration,
    * User Settings,
    * Session (Log in/out),
    * Email Conformation,
    * Rassword Reset,
    * Plug Middleware (Load/require user)

Далее необходимо обновить зависимости:

```bash
mix deps.get
```

## 5. Проверка тестов

```bash
mix test
```

## 6. Добавление поля имени пользователя

Добавить поле в модель:

```elixir
defmodule ThriftBox.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :email, :string
    field :name, :string
    field :password, :string, virtual: true, redact: true
    ...
```

Создать миграцию:

```bash
mix ecto.gen.migration add_user_name
#                       ^^^^^^^^^
#                    имя файла миграции
```

Обновить файл миграции:

```elixir
defmodule ThriftBox.Repo.Migrations.AddUserName do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :name, :string
    end

  end
end
```

Проверить

```bash
mix test
```

