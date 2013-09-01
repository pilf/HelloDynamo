defmodule ApplicationRouter do
  require HelloDynamo.Access
  use Dynamo.Router

  prepare do
    # Pick which parts of the request you want to fetch
    # You can comment the line below if you don't need
    # any of them or move them to a forwarded router
    conn.fetch([:cookies, :params])
  end

  # It is common to break your Dynamo into many
  # routers, forwarding the requests between them:
  # forward "/posts", to: PostsRouter

  get "/" do
    conn = conn.assign(:title, "Welcome to Dynamo!")
    render conn, "index.html"
  end

  get "/hello" do
    conn.resp(200, "Sorry, didn't catch your name.  Well, hello to you to... whoever you are.  <squinty_eyes.jpg>")
  end
  get "/hello/:name" do
    name = conn.params[:name]
    { :ok, pid } = HelloDynamo.Access.start_link
    helloed = :gen_server.call pid, { :already_helloed, name }

    :gen_server.cast pid, { :hello, name }

    conn.resp(200, "Hello #{conn.params[:name]} - #{helloed}")
  end
end
