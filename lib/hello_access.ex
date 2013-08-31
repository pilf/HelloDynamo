defmodule HelloDynamo.Access do
  require Exquisite
  require Amnesia

  use GenServer.Behaviour

  #####
  # External API

  def start_link() do
    :gen_server.start_link(__MODULE__, [], [])
  end

  #####
  # GenServer implementation

  def init(_) do
    Amnesia.start
    HelloDb.create
    HelloDb.wait
    { :ok, {} }
  end

  def handle_call({:person_already_helloed, input}, _, _) do
#    use HelloDb
     already_helloed = Exquisite.match HelloDb.PastSalutations, where: name == "input"
    Amnesia.transaction do
      { _, matches, _ } = HelloDb.PastSalutations.select already_helloed |> Enum.count
    end
    { :reply, true, nil }
  end
end
    
