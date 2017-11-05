import unittest
import requests

class HandlerIntegrationTest(unittest.TestCase):
    def test_can_get_created_metric(self):
        url = 'http://127.0.0.1:3000/hello'
        metricExtra = {
            'key1':'value1',
            'key2':'value2'      
        }
        response = requests.post(url, json=metricExtra)
        self.assertEqual(200, response.status_code)
        self.assertEqual('OK', response.json())

if __name__ == '__main__':
    unittest.main()
