import os
import sys


def gettext(s): return s


DATA_DIR = os.path.dirname(os.path.dirname(__file__))
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

ROOT_URLCONF = 'engine.urls'
WSGI_APPLICATION = 'engine.wsgi.application'

LANGUAGE_CODE = 'ru'
TIME_ZONE = 'Europe/Moscow'
USE_I18N = True
USE_L10N = True
USE_TZ = True

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [os.path.join(BASE_DIR, 'templates'), ],
        'OPTIONS': {
            'context_processors': [
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
                'django.template.context_processors.i18n',
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.template.context_processors.media',
                'django.template.context_processors.csrf',
                'django.template.context_processors.tz',
                # 'sekizai.context_processors.sekizai', # Django CMS http://docs.django-cms.org/en/latest/
                'django.template.context_processors.static',
                # 'cms.context_processors.cms_settings'
                'engine.context_processors.debug',
                'engine.context_processors.engine_version',
            ],
            'loaders': [
                'django.template.loaders.filesystem.Loader',
                'django.template.loaders.app_directories.Loader',
                'django.template.loaders.eggs.Loader'
            ],
        },
    },
]


MIDDLEWARE = [
    # 'cms.middleware.utils.ApphookReloadMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.locale.LocaleMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
    # 'cms.middleware.user.CurrentUserMiddleware',
    # 'cms.middleware.page.CurrentPageMiddleware',
    # 'cms.middleware.toolbar.ToolbarMiddleware',
    # 'cms.middleware.language.LanguageCookieMiddleware'
]

INSTALLED_APPS = [
    # 'djangocms_admin_style',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.admin',
    # 'django.contrib.sites',
    'django.contrib.sitemaps',
    'django.contrib.staticfiles',
    'django.contrib.messages',

    # Django CMS http://docs.django-cms.org/en/latest/
    # 'cms',
    # 'menus',
    # 'sekizai',
    # 'treebeard',
    # 'djangocms_text_ckeditor',
    # 'filer',
    # 'easy_thumbnails',
    # 'djangocms_column',
    # 'djangocms_link',
    # 'cmsplugin_filer_file',
    # 'cmsplugin_filer_folder',
    # 'cmsplugin_filer_image',
    # 'cmsplugin_filer_utils',
    # 'djangocms_style',
    # 'djangocms_snippet',
    # 'djangocms_googlemap',
    # 'djangocms_video',
    # // Django cms

    'engine',
]

LANGUAGES = (
    ('ru', gettext('ru')),
    ('en', gettext('en')),
)


# # Django CMS http://docs.django-cms.org/en/latest/
# CMS_LANGUAGES = {
#     ## Customize this
#     'default': {
#         'public': True,
#         'hide_untranslated': False,
#         'redirect_on_fallback': True,
#     },
#     1: [
#         {
#             'public': True,
#             'code': 'ru',
#             'hide_untranslated': False,
#             'name': gettext('ru'),
#             'redirect_on_fallback': True,
#         },
#     ],
# }
#
# CMS_TEMPLATES = (
#     ## Customize this
#     ('fullwidth.html', 'Fullwidth'),
#     ('sidebar_left.html', 'Sidebar Left'),
#     ('sidebar_right.html', 'Sidebar Right')
# )
#
# CMS_PERMISSION = True
#
# CMS_PLACEHOLDER_CONF = {}

MIGRATION_MODULES = {
}

THUMBNAIL_PROCESSORS = (
    'easy_thumbnails.processors.colorspace',
    'easy_thumbnails.processors.autocrop',
    'filer.thumbnail_processors.scale_and_crop_with_subject_location',
    'easy_thumbnails.processors.filters'
)

try:
    from .version import *
except:
    VERSION = {
        'version': '0.1.0',
        'date': '19910220',
        'revision': 1,
        'changes': {
            'Foo bar.',
        },
    }
    VERSION_STRING = '0.1.0-19910220-1'

from .settings_social import *

from .settings_local import *
if DEBUG == True:
    STATIC_URL = '/static-dev/'
    STATICFILES_DIRS = (
        os.path.join(BASE_DIR, 'static-dev'),
    )
    STATIC_ROOT = os.path.join(DATA_DIR, 'static')
else:
    STATIC_URL = '/static/'
    STATICFILES_DIRS = (
        os.path.join(BASE_DIR, 'static'),
    )

MEDIA_URL = '/media/'
MEDIA_ROOT = os.path.abspath(os.path.join(BASE_DIR, '..', 'data', 'media'))
