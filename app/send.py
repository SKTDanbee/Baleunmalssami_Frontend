import requests

# 파일 경로와 URL 설정
file_path = "/Users/hojoonkim/Downloads/ansim_report/KakaoTalk_1.txt"
url = "https://danbeegptreport-c4cfbdage7hkd8bv.koreacentral-01.azurewebsites.net/generate-report/"

# 파일을 POST 요청으로 전송
with open(file_path, 'rb') as f:
    files = {'file': f}
    response = requests.post(url, files=files)

# 응답 확인
print(f"Status Code: {response.status_code}")
print(f"Response Text: {response.text}")