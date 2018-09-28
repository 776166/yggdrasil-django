# -*- coding: <encoding name> -*-

from django.shortcuts import render
from django.template import RequestContext


def index(request):
    response = render(request, 'layouts/page_main.html', {})

    # response.status_code = 500
    return response
