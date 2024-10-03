Dummy::Application.routes.draw do
  mount Casino::Engine, at: '/', :as => 'casino'
end
