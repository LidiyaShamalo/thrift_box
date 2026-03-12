defmodule ThriftBoxWeb.Layouts do
  use ThriftBoxWeb, :html

  embed_templates "layouts/*"

  @doc "Для LiveView"
  attr :flash, :map, default: %{}
  attr :current_scope, :any, default: nil
  slot :inner_block, required: true
  def app(assigns)

  @doc "Для обычных контроллеров (Root)"
  attr :conn, :any
  attr :current_user, :any, default: nil
  attr :inner_content, :any, required: true
  def root(assigns)

  def flash_group(assigns) do
    ~H"""
    <div id="flash-group" class="fixed top-2 right-2 z-50">
      <.flash :if={@flash[:info]} kind={:info} title="Success!" flash={@flash} />
      <.flash :if={@flash[:error]} kind={:error} title="Error!" flash={@flash} />
    </div>
    """
  end

  def theme_toggle(assigns) do
    ~H"""
    <div class="flex border rounded p-1 gap-2 bg-base-200">
      <button class="px-2 hover:bg-base-300" phx-click={JS.dispatch("phx:set-theme")} data-phx-theme="light">L</button>
      <button class="px-2 hover:bg-base-300" phx-click={JS.dispatch("phx:set-theme")} data-phx-theme="dark">D</button>
    </div>
    """
  end
end
