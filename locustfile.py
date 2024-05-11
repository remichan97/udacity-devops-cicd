from locust import HttpUser, between, task

class WebTest(HttpUser):
	wait_time = between(0.5, 10)
 
	def on_start(self):
		return super().on_start()

	def on_stop(self):
		return super().on_stop()

	@task(1)
	def test_home(self):
		self.client.get("https://mirai-azure-flash-ml.azurewebsites.net")
  
	@task(2)
	def test_prediction(self):
		self.client.post("https://mirai-azure-flash-ml.azurewebsites.net:443/predict", 
		{"CHAS":{
          "0":0
       },
       "RM":{
          "0":6.575
       },
       "TAX":{
          "0":296.0
       },
       "PTRATIO":{
          "0":15.3
       },
       "B":{
          "0":396.9
       },
       "LSTAT":{
          "0":4.98
       }
    },
    headers="Content-Type: application/json")