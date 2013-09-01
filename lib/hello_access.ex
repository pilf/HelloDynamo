defmodule HelloDynamo.Access do
  require Exquisite
  require Amnesia
  require HelloDb

  use GenServer.Behaviour

  #####
  # External API

  def start_link do
    :gen_server.start_link __MODULE__, nil, []
  end

  #####
  # GenServer implementation

  def init _ do
    Amnesia.start
    HelloDb.create
    HelloDb.wait
    { :ok, nil }
  end

  def handle_call :sanity, _, _ do
    { :reply, "has sanity", nil }
  end

  def handle_call { :already_helloed, person_name }, _from, _ do
    matches = case run_already_helloed_query(person_name) do
      nil -> []
      { _, m, _ } -> m
    end
    ah? = matches |> Enum.count > 0
    { :reply, ah?, nil }
  end

  def run_already_helloed_query(person_name) do
    use HelloDb
    q = Exquisite.match PastSalutations, where: name == person_name
    Amnesia.transaction do: PastSalutations.select q
  end
end
    
