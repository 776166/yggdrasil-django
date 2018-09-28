# -*- coding: utf-8 -*-
from __future__ import absolute_import, print_function, unicode_literals

from django.conf import settings
from django.conf.urls import include, url

from django.contrib import admin
from django.contrib.sitemaps.views import sitemap
from django.contrib.staticfiles.urls import staticfiles_urlpatterns
from django.views.static import serve

# from django.conf.urls.i18n import i18n_patterns

from engine.views import index

admin.autodiscover()

urlpatterns = [
    url(r'^$', index.index),
    url(r'^django-admin/', admin.site.urls),

    url(r'^auth/', include('social_auth.urls')),
]

# urlpatterns += i18n_patterns(
#     url(r'^admin/', include(admin.site.urls)),  # NOQA
#     url(r'^', include('cms.urls')),
# )
