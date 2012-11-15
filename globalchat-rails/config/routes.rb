GlobalChatServer::Application.routes.draw do
  get "/signOn" => "global_chat#signOn"

  get "/getChatLog" => "global_chat#getChatLog"

  get "/getMessages" => "global_chat#getMessages"

  get "/postAChatMessage" => "global_chat#postAChatMessage"

  get "/getOnlineHandles" => "global_chat#getOnlineHandles"

  get "/signOff" => "global_chat#signOff"

  get '/' => "global_chat#root"

end
