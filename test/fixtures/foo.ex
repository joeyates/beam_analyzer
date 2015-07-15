defmodule Foo do
  #use Plug.Router
  
  #plug :match
    
  #match "/match_get_or_post", via: [:get, :post] do
  #  conn |> resp(200, "the response")
  #end

  #get "/aroute" do
  #  conn |> resp(200, "the response")
  #end

  #get "/with_variable/:bar" do
  #  conn |> resp(200, "bar = #{bar}")
  #end

  def amethod do
    "Ciao"
  end
end
