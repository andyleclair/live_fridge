defmodule LiveFridge.Fridge do
  use Ash.Domain

  resources do
    resource LiveFridge.Fridge.Word
    resource LiveFridge.Fridge.Fridge
  end
end
