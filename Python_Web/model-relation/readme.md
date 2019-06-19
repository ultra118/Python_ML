# M:N 관계

- django extension 설치

```bash
$ pip install django_extensions
```

- `model_relation/settings.py`의 `INSTALLED_APPS`

```python
INSTALLED_APPS = [
    # 3rd
    'django_extensions',
    # django apps
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
]
```

- startapp

```bash

- start project

```bash
$ django-admin startproject model_relation .
```

- start app

```bash
$ python manage.py startapp manytomany
```

### build model

```python
from django.db import models

# Create your models here.


class Doctor(models.Model):
    name = models.CharField(max_length=20)

    def __str__(self):
        return f'{self.id}번 의사 {self.name}'


class Patient(models.Model):
    name = models.CharField(max_length=20)
    # through 누구를 통해서 doctor를 가지고 오는지
    doctors = models.ManyToManyField(
        Doctor,
        # through='Reservation',
        # doctor도 patient를 바라볼때 realted_name으로 접근할 수 있게 속성 값 지정
        related_name='patients',
    )

    def __str__(self):
        return f'{self.id}번 환자 {self.name}'


# M:N을 중계하는 model
# class Reservation(models.Model):
#     doctor = models.ForeignKey(Doctor, on_delete=models.CASCADE)
#     patient = models.ForeignKey(Patient, on_delete=models.CASCADE)
#
#     def __str__(self):
#         return f'{self.doctor_id}번 의사 {self.patient_id}번 환자'

```

- migrate

```bash
$ python manage.py makemigrations
```

```bash
$ python manage.py migrate
```

- `python manage.py shell_plus`
  - model들을 알아서 import해주는 django shell

- ` python manage.py shell_plus`

```bash
In [1]: patient = Patient.objects.get(pk=1)

In [2]: patient
Out[2]: <Patient: 1번 환자 im>

In [3]: patient.reservation_set.all()
Out[3]: <QuerySet [<Reservation: 1번 의사 1번 환자>]>

In [4]: patient.doctors.all()
Out[4]: <QuerySet [<Doctor: 1번 의사 imsm>]>

In [5]: doctor = Doctor.objects.create(name='john')

In [6]: doctor
Out[6]: <Doctor: 2번 의사 john>

In [7]: Reservation.objects.create(doctor=doctor, patient=patient)
Out[7]: <Reservation: 2번 의사 1번 환자>

In [8]: patient.reservation_set.all()
Out[8]: <QuerySet [<Reservation: 1번 의사 1번 환자>, <Reservation: 2번 의사 1번 환자>]>

```

## 중계 model을 통하지않고 후보 키 값들을 가지고 옴

```bash
$ python manage.py shell_plus

In [1]: doctor = Doctor.objects.create(name='imsm')

In [2]: patient = Patient.objects.create(name='im')

In [3]: patient
Out[3]: <Patient: 1번 환자 im>

In [4]: doctor
Out[4]: <Doctor: 1번 의사 imsm>

In [5]: doctor.patients.add(patient)

In [6]: doctor
Out[6]: <Doctor: 1번 의사 imsm>

In [10]: doctor.patients.all()
Out[10]: <QuerySet [<Patient: 1번 환자 im>]>

In [11]: patient.doctors.all()
Out[11]: <QuerySet [<Doctor: 1번 의사 imsm>]>
# 삭제
In [12]: patient.doctors.remove(doctor)

In [13]: patient.doctors.all()
Out[13]: <QuerySet []>

In [14]: doctor.patients.all()
Out[14]: <QuerySet []>
```



