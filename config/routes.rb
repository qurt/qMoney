QMoney::Application.routes.draw do
    # Import
    controller :import do
        get 'import/operations' => :operations
        post 'import/operations' => :operations_progress
        get 'import/operations/list' => :operations_list
    end

    controller :repeat_operations do
        get 'repeat_operations' => :list
        get 'repeat_operations/:id' => :edit, as: :repeat_operations_edit
        put 'repeat_operations/:id' => :update
        delete 'repeat_operations/:id' => :delete, as: :repeat_operations_delete
    end

    get 'categories/delete/subcategory/all', to: 'categories#remove_subcategory'

    get 'notebook/list'

    get 'notebook/create/:id' => 'notebook#create'

    delete 'notebook/delete/:id' => 'notebook#destroy'

    resources :tags

    resources :moneyboxes

    get 'statistic/operations'
    get 'statistic/average_spending'

    resources :credits do
        collection do
            get 'transfer'
            post 'transfer_process'
        end
    end

    controller :sessions do
        get 'login' => :new
        post 'login' => :create
        delete 'logout' => :destroy
    end

    get 'sessions/create'
    get 'sessions/destroy'
    resources :users

    resources :categories

    resources :operations

    resources :accounts do
        get 'moneybox', on: :new
    end

    get 'home/index'
    # The priority is based upon order of creation: first created -> highest priority.
    # See how all your routes lay out with "rake routes".

    # You can have the root of your site routed with "root"
    root 'home#index'

    # Example of regular route:
    #   get 'products/:id' => 'catalog#view'

    # Example of named route that can be invoked with purchase_url(id: product.id)
    #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

    # Example resource route (maps HTTP verbs to controller actions automatically):
    #   resources :products

    # Example resource route with options:
    #   resources :products do
    #     member do
    #       get 'short'
    #       post 'toggle'
    #     end
    #
    #     collection do
    #       get 'sold'
    #     end
    #   end

    # Example resource route with sub-resources:
    #   resources :products do
    #     resources :comments, :sales
    #     resource :seller
    #   end

    # Example resource route with more complex sub-resources:
    #   resources :products do
    #     resources :comments
    #     resources :sales do
    #       get 'recent', on: :collection
    #     end
    #   end

    # Example resource route with concerns:
    #   concern :toggleable do
    #     post 'toggle'
    #   end
    #   resources :posts, concerns: :toggleable
    #   resources :photos, concerns: :toggleable

    # Example resource route within a namespace:
    #   namespace :admin do
    #     # Directs /admin/products/* to Admin::ProductsController
    #     # (app/controllers/admin/products_controller.rb)
    #     resources :products
    #   end
end
