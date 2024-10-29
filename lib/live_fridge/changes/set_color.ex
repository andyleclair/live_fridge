defmodule LiveFridge.Changes.SetColor do
  use Ash.Resource.Change
  alias Ash.Changeset
  
  @impl true
  def change(changeset, _opts, _context) do
    color = 
      changeset
      |> Changeset.get_attribute(:word)
      |> ColorHash.hash() 
      |> ColorHash.hsl_to_string()

    Changeset.change_attribute(changeset, :color, color)
  end

  @impl true
  def atomic(changeset, opts, context) do
    {:ok, change(changeset, opts, context)}
  end
end
