defmodule HelloDynamo.SanityServer do
  use GenServer.Behaviour

  def start_link do
    IO.puts "About to start the sanity server"
    :gen_server.start_link __MODULE__, nil, []
  end

  def are_you_sane? pid do
    :gen_server.call pid, :sanity
  end

  ##### 
  # Server

  def init _ do
    { :ok, nil }
  end

  def handle_call :sanity, _, _ do
    IO.puts "Does it even get here?"
    { :reply, "You are (mostly) sane my son", nil }
  end
end
  
