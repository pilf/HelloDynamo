# from: https://github.com/jschoch/elixir_cowboy_amnesia_eex/blob/master/lib/db.ex
use Amnesia
defmodule DBA do
  def install do
    Amnesia.Schema.create
    Amnesia.start
    DB.create()
    DB.wait
  end

  def install_disk do
    Amnesia.Schema.create
    Amnesia.start
    DB.create(disk: [node])
    DB.wait
  end

  def uninstall do
    Amnesia.start
    DB.destroy
    Amnesia.stop
    Amnesia.Schema.destroy
  end
end

defdatabase DB do
  deftable Tbl, [:id, :name], type: :ordered_set do
  end
end


