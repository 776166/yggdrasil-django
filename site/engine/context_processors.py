# -*- coding: utf-8 -*-

from django.conf import settings


def debug(request):
    """DEBUG mode for templates."""
    return {'debug': settings.DEBUG}


def engine_version(request):
    """Set current engine version for templates."""
    context = {
        'engine_version': settings.VERSION_STRING,
    }
    return context
