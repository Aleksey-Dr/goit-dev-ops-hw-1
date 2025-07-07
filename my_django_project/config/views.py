from django.http import HttpResponse

def home_page(request):
    return HttpResponse("<h1>Welcome to My Django Project!</h1><p>This is the home page.</p>")