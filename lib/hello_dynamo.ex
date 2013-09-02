defmodule HelloDynamo do
  use Application.Behaviour

  @doc """
  The application callback used to start this
  application and its Dynamos.
  """
  def start(_type, _args) do
    HelloDynamo.AccessSupervisor.start_link
  end
end
