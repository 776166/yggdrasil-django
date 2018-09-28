from django.contrib import admin
from .models.user import Profile


@admin.register(Profile)
class UserAdmin(admin.ModelAdmin):
    pass
