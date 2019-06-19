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
