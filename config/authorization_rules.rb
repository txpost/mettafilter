authorization do
  role :admin do
    has_permission_on :entries, :to => [:index, :show, :new, :edit, :create, :update, :destroy,
                                        :preview, :add_favorite, :add_favcom ]
    has_permission_on :comments, :to => [ :index, :create, :destroy, :show, :edit ]
    has_permission_on :users, :to => [:new, :show, :index, :destroy, :edit, :update, :posts, :comments,
                                      :favcoms, :favorites]
  end
  
  role :user do
    has_permission_on :entries, :to => [:index, :show, :new, :create, :preview, :add_favorite, :add_favcom ]
    has_permission_on :comments, :to => [ :index, :create, :show ]
    has_permission_on :users, :to => [:show, :user]
  end
  
  role :guest do 
    has_permission_on :entries, :to => [:index, :show]
    has_permission_on :users, :to => [:new, :create, :show]
  end
end
