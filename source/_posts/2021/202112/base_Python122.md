---
title: Python_基础 (122)
date: 2021-12-02
tags: Python
toc: true
---

### django自定义命令
    python manage.py xxxx

<!-- more -->

#### 前情提要
> django自定义命令我不太会呀 得看一看
- 编写自定义django-admin命令
    * 已经在 INSTALLED_APPS 中注册过 polls 应用
    * python manage.py colsepoll 1 2 3
    ```bash
        $ tree
        polls/
            __init__.py
            models.py
            management/
                __init__.py
                commands/
                    __init__.py
                    _private.py
                    closepoll.py
            tests.py
            views.py
    ```
    ```python
        # polls/management/commands/closepoll.py
        from django.core.management.base import BaseCommand, CommandError
        from polls.models import Question as Poll

        class Command(BaseCommand):
            help = 'Closes the specified poll for voting'

            def add_arguments(self, parser):
                parser.add_argument('poll_ids', nargs='+', type=int)

            def handle(self, *args, **options):
                for poll_id in options['poll_ids']:
                    try:
                        poll = Poll.objects.get(pk=poll_id)
                    except Poll.DoesNotExist:
                        raise CommandError('Poll "%s" does not exist' % poll_id)

                    poll.opened = False
                    poll.save()

                    self.stdout.write(self.style.SUCCESS('Successfully closed poll "%s"' % poll_id))
    ```
- 接受可选参数
    ```python
        class Command(BaseCommand):
            def add_arguments(self, parser):
                # Positional arguments
                parser.add_argument('poll_ids', nargs='+', type=int)

                # Named (optional) arguments
                parser.add_argument(
                    '--delete',
                    action='store_true',
                    help='Delete poll instead of closing it',
                )

            def handle(self, *args, **options):
                # ...
                if options['delete']:
                    poll.delete()
                # ...
    ```

