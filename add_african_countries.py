from django.db import transaction
from core.models import Country

countries = [
    ("Algeria", "DZA"), ("Angola", "AGO"),
    ("Benin", "BEN"), ("Botswana", "BWA"),
    ("Burkina Faso", "BFA"), ("Burundi", "BDI"),
    ("Cabo Verde", "CPV"), ("Cameroon", "CMR"),
    ("Central African Republic", "CAF"), ("Chad", "TCD"),
    ("Comoros", "COM"),
    ("Democratic Republic of the Congo", "COD"),
    ("Republic of the Congo", "COG"), ("Cote d'Ivoire", "CIV"),
    ("Djibouti", "DJI"), ("Egypt", "EGY"),
    ("Equatorial Guinea", "GNQ"), ("Eritrea", "ERI"),
    ("Eswatini", "SWZ"), ("Ethiopia", "ETH"),
    ("Gabon", "GAB"), ("Gambia", "GMB"),
    ("Ghana", "GHA"), ("Guinea", "GIN"),
    ("Guinea-Bissau", "GNB"), ("Kenya", "KEN"),
    ("Lesotho", "LSO"), ("Liberia", "LBR"),
    ("Libya", "LBY"), ("Madagascar", "MDG"),
    ("Malawi", "MWI"), ("Mali", "MLI"),
    ("Mauritania", "MRT"), ("Mauritius", "MUS"),
    ("Morocco", "MAR"), ("Mozambique", "MOZ"),
    ("Namibia", "NAM"), ("Niger", "NER"),
    ("Nigeria", "NGA"), ("Rwanda", "RWA"),
    ("Sao Tome and Principe", "STP"), ("Senegal", "SEN"),
    ("Seychelles", "SYC"), ("Sierra Leone", "SLE"),
    ("Somalia", "SOM"), ("South Africa", "ZAF"),
    ("South Sudan", "SSD"), ("Sudan", "SDN"),
    ("Tanzania", "TZA"), ("Togo", "TGO"),
    ("Tunisia", "TUN"), ("Uganda", "UGA"),
    ("Zambia", "ZMB"), ("Zimbabwe", "ZWE"),
]

created = 0
existing = 0

with transaction.atomic():
    for name, code in countries:
        old = Country.objects.filter(name__iexact=name).first()
        if old:
            existing += 1
            continue

        if Country.objects.filter(code=code).exists():
            existing += 1
            continue

        Country.objects.create(name=name, code=code)
        created += 1

print("African countries in list:", len(countries))
print("New countries added:", created)
print("Already existing:", existing)
print("Total countries in database:", Country.objects.count())
print("Tanzania record:", list(
    Country.objects.filter(name__iexact="Tanzania").values("id", "name", "code")
))
