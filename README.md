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

## Зайти в БД

```bash
sudo -u postgres psql -d thrift_box_dev
```

проверить список отношений:

```psql
thrift_box_dev=# \dt
```

## Phoenix LiveView forms

### Этапы прохождения Form

***LiveView*** (отобразит форму - registration.ex) ---renders a---> ***Form*** (форма будет ссылаться на набор изменений - user.ex) ---references a---> ***Changeset***(определяется в схеме) ---defined with a---> ***Schema***(ThriftBox.Accounts.User -> добавление поля имени) ---migrated into the---> ***Database***(создали миграцию ThriftBox.Repo.Migrations.AddUserName - командой $ mix ecto.gen.migration add_user_name)




iex(1)> ThriftBox.Tracking.create_budget()
{:error,
 #Ecto.Changeset<
   action: :insert,
   changes: %{},
   errors: [
     name: {"can't be blank", [validation: :required]},
     start_date: {"can't be blank",
      [validation: :required]},
     end_date: {"can't be blank", [validation: :required]},
     creator_id: {"can't be blank",
      [validation: :required]}
   ],
   data: #ThriftBox.Tracking.Budget<>,
   valid?: false,
   ...
 >}


 Используем уже существующего пользователя:

```bash
 iex(2)> user = ThriftBox.Accounts.get_user_by_email("1111@com")
[debug] QUERY OK source="users" db=15.6ms queue=1.6ms idle=1382.7ms
SELECT u0."id", u0."email", u0."name", u0."hashed_password", u0."confirmed_at", u0."inserted_at", u0."updated_at" FROM "users" AS u0 WHERE (u0."email" = $1) ["1111@com"]
↳ :elixir.eval_external_handler/3, at: src/elixir.erl:371
#ThriftBox.Accounts.User<
  __meta__: #Ecto.Schema.Metadata<:loaded, "users">,
  id: "00b457f1-c610-4300-b611-1f843c35fa47",
  email: "1111@com",
  name: "Даша",
  confirmed_at: nil,
  authenticated_at: nil,
  inserted_at: ~U[2026-03-15 10:12:29Z],
  updated_at: ~U[2026-03-15 10:12:29Z],
  ...
```

и создадим бюджет: 

```bash
iex(3)> ThriftBox.Tracking.create_budget(%{
        name: "hello",
        start_date: ~D[2026-01-01],
        end_date: ~D[2026-01-31],
        creator_id: user.id
        })
[debug] QUERY OK source="budgets" db=14.9ms queue=1.1ms idle=1703.2ms
INSERT INTO "budgets" ("name","creator_id","end_date","start_date","inserted_at","updated_at","id") VALUES ($1,$2,$3,$4,$5,$6,$7) ["hello", "00b457f1-c610-4300-b611-1f843c35fa47", ~D[2026-01-31], ~D[2026-01-01], ~U[2026-03-15 13:12:27Z], ~U[2026-03-15 13:12:27Z], "733a49ca-17c8-48b3-b15a-566ae5ab2421"]
↳ :elixir.eval_external_handler/3, at: src/elixir.erl:371
{:ok,
 %ThriftBox.Tracking.Budget{
   __meta__: #Ecto.Schema.Metadata<:loaded, "budgets">,
   id: "733a49ca-17c8-48b3-b15a-566ae5ab2421",
   name: "hello",
   description: nil,
   start_date: ~D[2026-01-01],
   end_date: ~D[2026-01-31],
   creator_id: "00b457f1-c610-4300-b611-1f843c35fa47",
   creator: #Ecto.Association.NotLoaded<association :creator is not loaded>,
   inserted_at: ~U[2026-03-15 13:12:27Z],
   updated_at: ~U[2026-03-15 13:12:27Z]
 }
}
 ```


 ## dfd

 ```bash
  mix phx.gen.schema
 ```
 