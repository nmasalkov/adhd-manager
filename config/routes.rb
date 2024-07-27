Rails.application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    devise_for :users, controllers: {
      registrations: 'users/registrations'
    }
    resources :rewards
    root to: 'quests#index'

    resources :quests do
      member do
        patch :toggle_status
      end
    end
  end
end
