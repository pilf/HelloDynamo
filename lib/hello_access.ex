defmodule HelloDynamo.Access do
  require Exquisite
  require Amnesia
  require HelloDb

  use GenServer.Behaviour

  #####
  # External API

  def start_link do
    :gen_server.start_link { :local, :hello_db }, __MODULE__, nil, []
  end

  def already_helloed?(name) do
    :gen_server.call :hello_db, { :already_helloed, name }
  end

  def hello(name) do
    :gen_server.cast :hello_db, { :hello, name }
  end

  #####
  # GenServer implementation

  def init _ do
    Amnesia.Schema.create
    Amnesia.start
    HelloDb.create disk: [ node ]
    HelloDb.wait
    { :ok, nil }
  end

  def terminate(_reason, _state) do
    HelloDb.stop
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

  def handle_cast { :hello, person_name }, _ do
    use HelloDb
    Amnesia.transaction! do 
      PastSalutations[ 
        name: person_name, 
        number_of_hellos: 1 ].write
    end

    { :noreply, nil }
  end

  def run_already_helloed_query(person_name) do
    use HelloDb
    q = Exquisite.match PastSalutations, where: name == person_name
    Amnesia.transaction do: PastSalutations.select q
  end
end
    
