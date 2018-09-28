# encoding=utf-8
from django.conf.urls import url
from django.conf.urls import include

from .views import social_auth as social_views

# app_name = 'contacts'
urlpatterns = [
    url(r'^email-sent/',    social_views.validation_sent),
    url(r'^login/$',        social_views.home),
    url(r'^logout/$',       social_views.logout),
    url(r'^done/$',         social_views.done, name='done'),
    url(r'^ajax-auth/(?P<backend>[^/]+)/$',
        social_views.ajax_auth, name='ajax-auth'),
    url(r'^email/$',        social_views.require_email, name='require_email'),
    url(r'^/', include('social_django.urls', namespace='social')),
    url(r'^policy/$',       social_views.policy),
    url(r'^agreement/$',    social_views.agreement),
]
