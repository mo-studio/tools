import gitlab
from dotenv import load_dotenv
import os

load_dotenv()

gl = gitlab.Gitlab('https://gitlab-dev.bespinmobile.cloud/', private_token=os.getenv('PRIVATE_TOKEN'))

# use this to search for your gitlab group and take note of its ID
gitlabGroups = gl.groups.list()

print("=====GROUPS=====")
for group in gitlabGroups:
    print(f'GROUP NAME: {group.full_name}\nGROUP ID: {group.id}\n')

# myGroup = gl.groups.get(#YOUR_GROUP_ID)

# # this outputs all repos for your group. Make sure to grab relevant project IDs for use in duplicate-tickets.py

# myGroupRepos = myGroup.projects.list()

# print("======PROJECTS======")
# for project in myGroupRepos:
#     print(f'PROJECT NAME: {project.name}\nPROJECT ID: {project.id}\n')