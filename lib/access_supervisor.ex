defmodule HelloDynamo.AccessSupervisor do
  use Supervisor.Behaviour

  def start_link do
    :supervisor.start_link(__MODULE__, nil)
  end

  def init(_) do
    children = [ 
      worker(HelloDynamo.Access, []),
      supervisor(HelloDynamo.Dynamo, [] )
    ]
    supervise children, strategy: :one_for_one
  end
end

