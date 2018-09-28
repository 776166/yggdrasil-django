# -*- coding: <encoding name> -*-

from django.db import models
from django.db.models.signals import post_save

from django.contrib.auth.models import AbstractUser
from django.contrib.auth.models import User

from django.dispatch import receiver

from social_django.models import AbstractUserSocialAuth
from social_django.models import DjangoStorage
from social_django.models import USER_MODEL


class CustomUserSocialAuth(AbstractUserSocialAuth):
    user = models.ForeignKey(USER_MODEL,
                             related_name='custom_social_auth',
                             on_delete=models.CASCADE,
                             )


class CustomDjangoStorage(DjangoStorage):
    user = CustomUserSocialAuth


class Profile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    birth_date = models.DateField(null=True, blank=True)

    telegram_id = models.IntegerField(null=True)


@receiver(post_save, sender=User)
def create_user_profile(sender, instance, created, **kwargs):
    if created:
        Profile.objects.create(user=instance)


@receiver(post_save, sender=User)
def save_user_profile(sender, instance, **kwargs):
    try:
        Profile.objects.get(user=instance)
    except Profile.DoesNotExist:
        Profile.objects.create(user=instance)
    instance.profile.save()
