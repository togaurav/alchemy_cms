authorization do

  role :guest do
    has_permission_on :alchemy_pages, :to => [:show] do
      if_attribute :public => true, :restricted => false
    end
    has_permission_on :alchemy_elements, :to => [:show] do
      if_attribute :public => true
    end
    has_permission_on :alchemy_pictures, :to => [:show]
    has_permission_on :attachments, :to => [:show, :download]
  end

  role :registered do
    includes :guest
    has_permission_on :alchemy_pages, :to => [:show] do
      if_attribute :public => true
    end
    has_permission_on :alchemy_admin_users, :to => [:edit, :update] do
      if_attribute :id => is {user.id}
    end
  end

  role :author do
    includes :registered
    has_permission_on :alchemy_admin_dashboard, :to => [:index]
    has_permission_on :alchemy_pictures, :to => [:thumbnail]
    has_permission_on :alchemy_admin_pages, :to => [:index, :fold, :edit_page_content, :link]
    has_permission_on :alchemy_admin_elements, :to => [:manage_elements]
    has_permission_on :alchemy_admin_pictures, :to => [:index, :archive_overlay, :show_in_window]
    has_permission_on :alchemy_admin_attachments, :to => [:index, :archive_overlay, :show, :download]
    has_permission_on :alchemy_admin_contents, :to => [:manage_contents]
    has_permission_on :alchemy_admin_essence_pictures, :to => [:manage_picture_essences]
    has_permission_on :alchemy_admin_essence_files, :to => [:manage_file_essences]
    has_permission_on :alchemy_admin_users, :to => [:index]
    has_permission_on :alchemy_admin_trash, :to => [:index, :clear]
    has_permission_on :alchemy_admin_clipboard, :to => [:index, :insert, :remove, :clear]
    has_permission_on :alchemy_elements, :to => [:edit]
  end

  role :editor do
    includes :author
    has_permission_on :alchemy_admin_attachments, :to => [:manage]
    has_permission_on :alchemy_admin_pictures, :to => [:manage, :flush, :delete_multiple, :edit_multiple, :update_multiple]
    has_permission_on :alchemy_admin_pages, :to => [:manage_pages]
    has_permission_on :alchemy_admin_layoutpages, :to => [:index]
  end

  role :admin do
    includes :editor
    has_permission_on :alchemy_admin_users, :to => [:manage]
    has_permission_on :alchemy_admin_languages, :to => [:manage]
    has_permission_on :authorization_rules, :to => :read
  end

end

privileges do

  # default privilege hierarchies to facilitate RESTful Rails apps
  privilege :manage,  :includes => [:create, :read, :update, :delete]
  privilege :read,    :includes => [:index, :show]
  privilege :create,  :includes => :new
  privilege :update,  :includes => :edit
  privilege :delete,  :includes => :destroy

  privilege :manage_pages, :alchemy_admin_pages do
    includes :manage, :switch_language, :sort, :order, :configure, :flush, :copy, :copy_language_tree
  end

  privilege :manage_elements, :alchemy_admin_elements do
    includes :manage, :copy_to_clipboard, :order, :fold, :list, :trash
  end

  privilege :manage_contents, :alchemy_admin_contents do
    includes :manage, :order
  end

  privilege :manage_picture_essences, :alchemy_admin_essence_pictures do
    includes :manage, :save_link, :assign, :crop
  end

  privilege :manage_file_essences, :alchemy_admin_essence_files do
    includes :manage, :assign
  end

  privilege :edit_page_content, :alchemy_admin_pages do
    includes :edit, :unlock, :show, :publish, :visit
  end

end
