Rails.application.routes.draw do
  constraints(Api::Subdomain) do
    scope module: 'api/v1', path: 'v1' do
      resource :session, only [:create]
    end
  end
end
