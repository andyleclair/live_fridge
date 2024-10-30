defmodule LiveFridge.Validations.IsProfanity do
  use Ash.Resource.Validation

  @impl true
  def init(opts) do
    {:ok, opts}
  end

  @impl true
  def validate(changeset, _opts, _context) do
    config = Expletive.configure(blacklist: Expletive.Blacklist.english())
    word = Ash.Changeset.get_attribute(changeset, :word)

    if Expletive.profane?(word, config) do
      {:error, field: :word, message: "Nasty language, be nice!"}
    else
      :ok
    end
  end

  @impl true
  def atomic(changeset, opts, context) do
    validate(changeset, opts, context)
  end
end
