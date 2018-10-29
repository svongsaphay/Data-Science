from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import Select
from selenium.common.exceptions import NoSuchElementException
from selenium.common.exceptions import NoAlertPresentException
import unittest
import time
import csv
import re

driver = webdriver.Chrome(r'C:\Users\Sounithtra\NYC Data Science Academy\chromedriver.exe')

#Go to the page that we want to scrape
current_url = "https://brokercheck.finra.org/"
driver.get(current_url)
driver.find_element_by_id("acIndividualLocationId").click()
driver.find_element_by_id("acIndividualLocationId").clear()

#Select the city you want to scrape
driver.find_element_by_id("acIndividualLocationId").send_keys("Newport, RI")
time.sleep(2)
driver.find_element_by_xpath("//ul[@id='ul-3']/li/md-autocomplete-parent-scope/span/span").click()
time.sleep(2)
driver.find_element_by_xpath("//button[@type='submit']").click()
time.sleep(2)
driver.find_element_by_xpath("//div[2]/button").click()
time.sleep(2)

#Refine search to only get brokers that are actively registered
driver.find_element_by_xpath("//div[4]/md-checkbox/div").click()
driver.find_element_by_xpath("//div[2]/div/div[4]/md-checkbox/div").click()
driver.find_element_by_xpath("//div[2]/div/div[5]/md-checkbox/div").click()

csv_file = open('broker_summary.csv', 'w', newline='')
writer = csv.writer(csv_file , delimiter=';')
writer.writerow(['Broker_name','Current_employer','Company_address','Required_examination'])

# Page index used to keep track of where we are.
page_index = 1

# Initialize two variables refer to the next button on the current page and previous page.
prev_button = None
current_button = None

while True:
    try:

        if prev_button is not None:
            WebDriverWait(driver, 10).until(EC.staleness_of(prev_button))

        print("Scraping Page number " + str(page_index))
        page_index = page_index + 1

        # Find all the brokers' summary on the page
        wait_summary = WebDriverWait(driver, 10)

        summaries = wait_summary.until(EC.visibility_of_all_elements_located((By.XPATH,
                                                                         "//md-grid-list//md-grid-tile")))

        summaries_size = len(summaries)

        # Iterate through the list and find the details of each summary.
        for summary_index in range(summaries_size):
            summary = driver.find_elements_by_xpath("//md-grid-list//md-grid-tile")[summary_index]

            summary_dict = {}
            #Broker_name
            try:
                Broker_name = summary.find_element_by_xpath('./figure/div/div/md-card[1]/md-card-header/md-card-header-text/bc-bio-geo-section/div/div[1]/div[1]/span').text
                summary_dict['Broker_name'] = Broker_name
            except:
                summary_dict['Broker_name'] = None

            # drill down to details
            url = summary.find_element_by_xpath('./figure/div/div/md-card[1]/md-card-actions/a')
            summary.find_element_by_link_text(url.text).click()
            time.sleep(8)

            #Current_employer
            try:
                Current_employer = driver.find_element_by_xpath('//div[@class="bold ng-binding"]').text
                summary_dict['Current_employer'] = Current_employer
            except:
                summary_dict['Current_employer'] = None

            #Company_address
            try:
                Company_address1 = driver.find_element_by_xpath('//*[@id="bio-geo-summary"]/div[2]/div[3]/div[1]/div[3]/div[1]/span[1]').text
                Company_address2 = driver.find_element_by_xpath('//*[@id="bio-geo-summary"]/div[2]/div[3]/div[1]/div[3]/div[1]/span[2]').text
                Company_city = driver.find_element_by_xpath('//*[@id="bio-geo-summary"]/div[2]/div[3]/div[1]/div[3]/div[2]/span[1]').text
                Company_state = driver.find_element_by_xpath('//*[@id="bio-geo-summary"]/div[2]/div[3]/div[1]/div[3]/div[2]/span[3]').text
                Company_zip = driver.find_element_by_xpath('//*[@id="bio-geo-summary"]/div[2]/div[3]/div[1]/div[3]/div[2]/span[4]').text

                summary_dict['Company_address'] = Company_address1 + ', ' + Company_address2 + ', ' + Company_city + ', ' + Company_state + ' ' + Company_zip
            except:
                summary_dict['Company_address'] = None

            #Required_examination
            if(driver.find_elements_by_xpath("//*[contains(text(), 'Series 7 - General Securities Representative Examination')]")==[]):
                summary_dict['Required_examination'] = 'Did not pass Series 7 - General Securities Representative Examination'
           
            else:
                summary_dict['Required_examination'] = 'Passed Series 7 - General Securities Representative Examination'


            #Back to results
            wait_return_button = WebDriverWait(driver, 10)
            return_button = wait_return_button.until(EC.element_to_be_clickable((By.XPATH, '//*[contains(@class,"gobacklink font-light-gray ng-scope flex-xs-30 flex-40")]')))
            return_button.click()

            writer.writerow(summary_dict.values())
            time.sleep(9)

        # Locate the next button on the page.
        wait_button = WebDriverWait(driver, 10)
        current_button = wait_button.until(EC.element_to_be_clickable((By.XPATH,'//li[@class="pagination-next ng-scope"]')))
        prev_button = current_button
        current_button.click()


    except Exception as e:
        print(e)
        csv_file.close()
        driver.close()
        break