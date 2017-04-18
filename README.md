Grid Editor Integration
=======================
Этот проект позволяет интегрировать в приложения на основе RubyOnRails [SetkaEditor](http://ru.setka.io/editor/) - удобный плагин для оформления статей.

Gem предоставляет возможность [скачивания и обновления плагина](app/controllers/grid/editor_integration/config_controller.rb), [создания сниппетов](app/controllers/grid/editor_integration/snippets_controller.rb).

Поскольку плагин может храниться не только в локальной файловой системе, мы реализовали [хранилища](lib/grid/editor_integration/storages/abstract.rb) - [файловое](lib/grid/editor_integration/storages/file.rb) и [S3](lib/grid/editor_integration/storages/s3.rb). Также при необходимости можно реализовать свой класс хранилища и использовать его.

Также рекомендуем ознакомиться с [примером приложения, использующим интеграцию](spec/test_app)

Установка
---------
Добавьте в Gemfile строку
```gem 'grid-editor-integration', git: 'ssh://git@grid-editor-integration.git'```
Либо установите gem вручную.

Настройка
---------
Необходимо задать параметры
```
Grid::EditorIntegration.token
Grid::EditorIntegration.storage
```

По-умолчанию будет использоваться [файловое](lib/grid/editor_integration/storages/file.rb) хранилище. Все параметры и их значения по-умолчанию можно посмотреть [здесь](lib/grid/editor_integration.rb)

This uses MIT-LICENSE
