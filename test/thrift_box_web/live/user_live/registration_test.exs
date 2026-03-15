defmodule ThriftBoxWeb.UserLive.RegistrationTest do
  use ThriftBoxWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import ThriftBox.AccountsFixtures

  describe "Registration page" do
    test "renders registration page", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/users/register")

      assert html =~ "Register"
      assert html =~ "Log in"
    end

    test "redirects if already logged in", %{conn: conn} do
      result =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/users/register")
        |> follow_redirect(conn, ~p"/")

      assert {:ok, _conn} = result
    end

    test "renders errors for invalid data", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/users/register")

      #Добавлю пока имитацию ввода
      lv |> form("#registration_form", user: %{"email" => "invalid"}) |> render_change()

      result =
        lv
        |> form("#registration_form", user: %{ #element("#registration_form")
        #|> render_change(user: %{
          "email" => "with spaces",
          "name" => "а",
          "password" => "12"
          })
        |> render_submit()

      assert result =~ "must have the @ sign and no spaces"
      assert result =~ "Имя должно быть от 2 до 100 символов" # Ваша ошибка из validate_name
      assert result =~ "should be at least 4 character(s)"
    end
  end

  describe "register user" do
    test "creates account but does not log in", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/users/register")

      email = unique_user_email()
      form = form(lv, "#registration_form", user: %{
        "email" => email,
        "name" => "Some Name",
        "password" => "hello_world_1"
        })

      {:ok, _lv, html} =
        render_submit(form)
        |> follow_redirect(conn, ~p"/users/log-in")

      assert html =~
              ~r/An email was sent to .*, please access it to confirm your account/
    end

    test "renders errors for duplicated email", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/users/register")

      user = user_fixture(%{
        email: "test@email.com",
        name: "Existing",
        password: "password_1234"})

      result =
        lv
        |> form("#registration_form",
          user: %{
            "email" => user.email,
            "name" => "New User",
            "password" => "012345678910"
          }
        )
        |> render_submit()

      assert result =~ "has already been taken"
    end
  end

  describe "registration navigation" do
    test "redirects to login page when the Log in button is clicked", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/users/register")

      {:ok, _login_live, login_html} =
        lv
        |> element("main a", "Log in")
        |> render_click()
        |> follow_redirect(conn, ~p"/users/log-in")

      assert login_html =~ "Log in"
    end
  end
end
