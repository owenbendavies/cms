if defined? Bullet
  Rails.application.config.after_initialize do
    Bullet.enable = true
    Bullet.raise = true

    Bullet.add_whitelist(
      type: :n_plus_one_query,
      class_name: 'Site',
      association: :main_menu_pages
    )

    Bullet.add_whitelist(
      type: :counter_cache,
      class_name: 'Site',
      association: :main_menu_pages
    )
  end
end
