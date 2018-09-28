# -*- coding: <encoding name> -*-

from django.core.management.base import BaseCommand

from engine.version import VERSION_STRING


class Command(BaseCommand):
    """Return engine version.

    Returns:
        format <version in x.x.x format>-<date in YYYYMMDD format>-<revision whatever>
        Ex: '0.1.0-19910220-1'
    """
    help = 'Engine version (example: \'0.1.0-19910220-1\')'

    def handle(self, *args, **options):
        return(VERSION_STRING)
        # print('%s-%s-%s' % (settings.VERSION['version'], settings.VERSION['date'], settings.VERSION['revision']))
