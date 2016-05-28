[![Build Status](https://travis-ci.org/okodo/taskm.svg?branch=master)](http://travis-ci.org/okodo/taskm)

# Task Manager
Приложение было сделано в качестве тестового задания.

## Описание потребностей

Реализовать функционал Task Manager в соответствии с требованиями к приложению и требованиям к коду (ruby и rails style guide [[1]](https://github.com/arbox/ruby-style-guide/blob/master/README-ruRU.md), [[2]](https://github.com/arbox/rails-style-guide/blob/master/README-ruRU.md)).

Требования к тестовому заданию взяты из реальных проектов. Выполнение задания позволит ознакомиться с различными инструментами и гемами, которые используются в реальных проектах, подходами к построению архитектуры приложения.

### Требования к реализации:

* Сделать главную страницу приложения, на которой выводится список всех задач в системе с указанием идентификатора задачи, времени создания, названия и пользователя, на которого назначена задача.
* Сделать страницу авторизации пользователя в систему Task Manager.
* После авторизации пользователь попадает на страницу списка своих задач (личный кабинет). В этом списке выводятся задачи со следующими атрибутами: идентификатор задачи, название, описание, статус задачи, время создания.
* Сделать возможность добавления, редактирования и удаления задач пользователем из списка задач в личном кабинете.
* Если пользователь - admin, то в списке задач в личном кабинете он видит все задачи в системе. При этом в таблице списка задач указывается ещё пользователь, на которого назначена задача. Он может назначать, редактировать и удалять задачи других пользователей.
* Реализовать прикрепления файла к задаче. Использовать гем carrierwave.
* Сделать страницу просмотра задачи в личном кабинете. На странице выводится информация о задаче: идентификатор задачи, название, описание задачи, время создания. Если к задаче была прикреплена картинка, то отобразить картинку, иначе отобразить ссылку на скачивание файла. Если пользователь - admin, то выводить пользователя, на которого назначена задача.
* Реализовать смену состояния задачи отдельными переключателями в списке задач.

### Требования к бизнес-логике:

* Модель User. Атрибуты - email (уникальное поле), password, role (роль пользователя - admin, user, можно отдельным полем(атрибутом)).
* Модель Task. Атрибуты - name, description, user, state. Возможные значения state - new, started, finished. Задача не может существовать без имени.

Реализовать связь one-to-many между User и Task. Обеспечить целостность данных при удалении объектов (задача не может существовать без пользователя).

Для реализации state machine использовать гем state_machines-activerecord или aasm.


### Требования к контроллерам

* Реализовать иерархию контроллеров [[3]](http://habrahabr.ru/post/136461/)
* Не использовать scaffold.
* Реализовать кастомную авторизацию, не использовать гем devise.
* REST.

###  Требования к вьюхам

* Использовать гем simple_form для реализации форм.
* Шаблонизатор - haml/slim.
* Twitter Bootstrap 3 для вёрстки.

### Требования к тестированию

* TDD.
* Код покрыть  функциональными тестами.
* Тестовое покрытие кода >92 %. Проверка через гем simplecov.

### Требования к развёртыванию

* Код разместить на github.
* Прикрутить travis ci.
* При наличие собственного внешнего сервера выложить приложение на сервер и прикрутить capistrano для деплоя. При отсутствии - выложить на Heroku.
* Написать rake-таск для создания фейковых данных. Использовать гем faker.
* Создать учётку admin и user и поместить в seeds.


### Оценка задания

При оценке тестового задания будут учитываться следующие пункты:

* Выполнение требований к заданию.
* Следование style guides.
* Следование требованиям к тестированию, полнота тестов.
* DRY.

### Справочная информация

1. [Ruby Style Guide](https://github.com/arbox/ruby-style-guide/blob/master/README-ruRU.md)

2. [Rails Style Guide](https://github.com/arbox/rails-style-guide/blob/master/README-ruRU.md)

3. [Иерархия контроллеров](http://habrahabr.ru/post/136461/)

4. [Rusrails: Ruby on Rails по-русски](http://rusrails.ru/)