defmodule LiveFridgeWeb.Layouts do
  @moduledoc """
  This module holds different layouts used by your application.

  See the `layouts` directory for all templates available.
  The "root" layout is a skeleton rendered as part of the
  application router. The "app" layout is set as the default
  layout on both `use LiveFridgeWeb, :controller` and
  `use LiveFridgeWeb, :live_view`.
  """
  use LiveFridgeWeb, :html

  embed_templates "layouts/*"

  attr :href, :string, required: true
  slot :inner_block, required: true

  def ext_link(assigns) do
    ~H"""
    <a href={@href} target="_blank" class="underline">
      <%= render_slot(@inner_block) %>
    </a>
    """
  end
end
