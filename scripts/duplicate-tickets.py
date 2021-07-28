import gitlab
from dotenv import load_dotenv
import os
import itertools

def flatten_array(projects):
    flatten_projects = []
    for project in projects:
        if isinstance(project,list):
            for project_item in project:
                flatten_projects.append(project_item)
        else:
            flatten_projects.append(project)
    return flatten_projects

def subtract1(numberProject):
    return int(numberProject) - 1

def retrieveIssue(projectId, issueId, comment):
    gl.projects.get(projectId).issues.get(issueId).notes.create({'body': comment})
    project = gl.projects.get(projectId)
    issue = project.issues.get(issueId)
    issue.labels.append('Status::Blocked')
    issue.labels.append('SDE::Not Applicable')
    issue.save()

def markNotApplicable():
    print("\n=====PROJECTS=====\n")
    print(issue['Project'])

    naOption = input("\nPlease input # of each project you wish to mark N/A \ni.e 1,2,3 to mark first 3 projects as N/A\n")

    selectedProjects = naOption.split(',')

    comment = input("\nPlease leave a comment explaining why issue is N/A\n")

    for item in selectedProjects:
        index = subtract1(item)
        projectId = issue['ProjectID'][index]
        issueId = issue['ID'][index]
        retrieveIssue(projectId, issueId, comment)

def markDuplicates():
    print("\n=====PROJECTS=====\n")
    print(issue['Project'])
    dupeOption = input("\nPlease input # of project you wish to mark as source repo\ni.e 2 for second in list\n")

    markedProject = subtract1(dupeOption)

    sourceProjectID = issue['ProjectID'][markedProject]
    sourceIssueID = issue['ID'][markedProject]
    sourceIssue = gl.projects.get(sourceProjectID).issues.get(sourceIssueID)

    projectsToLink = issue['ProjectID']
    issuesToLink = issue['ID']

    projectsToLink.pop(markedProject)
    issuesToLink.pop(markedProject)
    
    if len(projectsToLink) == len(issuesToLink):
        addCommentPrompt = input("Would you like to leave a comment on the source issue? y/n\n")
        if addCommentPrompt == "y":
            comment = input("Enter comment below:\n")
            sourceIssue.notes.create({'body': comment})

        for idx, proj in enumerate(projectsToLink):
            issueProject = gl.projects.get(proj)
            duplicateIssue = issueProject.issues.get(issuesToLink[idx])
            duplicateIssue.notes.create({'body': f'Duplicate, [see here]({sourceIssue.web_url})'})
            duplicateIssue.labels.append('Status::Blocked')
            duplicateIssue.labels.append('SDE::Duplicate')
            duplicateIssue.save()
    else:
        print("====ERROR====")
        print("unequal list lengths will break the for loop")

def skip():
    return

load_dotenv()

gl = gitlab.Gitlab('https://gitlab-dev.bespinmobile.cloud/', private_token=os.getenv('PRIVATE_TOKEN'))

# replace these projects with any number of your own
dashboardProject = gl.projects.get(586)
uiProject = gl.projects.get(516)
apiProject = gl.projects.get(562)

dashboard = dashboardProject.issues.list(all=True)

ui = uiProject.issues.list(all=True)

api = apiProject.issues.list(all=True)

allIssues = []

# for each project you need a new for loop
# the for loops read all issues from each project, collects the relevant data into a dictionary, and appends it into a single array for the script
for issue in dashboard:
    singleIssue = {}
    singleIssue['ID'] = issue.iid
    singleIssue['Title'] = issue.title
    singleIssue['ProjectID'] = issue.project_id
    singleIssue['Description'] = issue.description
    singleIssue['Labels'] = issue.labels
    singleIssue['Project'] = 'Dashboard'
    allIssues.append(singleIssue)

for issue in api:
    singleIssue = {}
    singleIssue['ID'] = issue.iid
    singleIssue['Title'] = issue.title
    singleIssue['ProjectID'] = issue.project_id
    singleIssue['Description'] = issue.description
    singleIssue['Labels'] = issue.labels
    singleIssue['Project'] = 'Api'
    allIssues.append(singleIssue)

for issue in ui:
    singleIssue = {}
    singleIssue['ID'] = issue.iid
    singleIssue['Title'] = issue.title
    singleIssue['ProjectID'] = issue.project_id
    singleIssue['Description'] = issue.description
    singleIssue['Labels'] = issue.labels
    singleIssue['Project'] = 'Mobile'
    allIssues.append(singleIssue)

dupeIssues = []

for a,b in itertools.combinations(allIssues, 2):
    if a['Title'] == b['Title']:
        a['Project'] = [a['Project'], b['Project']]
        a['Project'] = flatten_array(a['Project'])

        a['ID'] = [a['ID'], b['ID']]
        a['ID'] = flatten_array(a['ID'])

        a['ProjectID'] = [a['ProjectID'], b['ProjectID']]
        a['ProjectID'] = flatten_array(a['ProjectID'])

        if a['Labels'].__contains__('Status::Blocked') or b['Labels'].__contains__('Status::Blocked'):
            continue
        elif a['Labels'].__contains__('Status::Done') or b['Labels'].__contains__('Status::Done'):
            continue
        if a not in dupeIssues:
            dupeIssues.append(a)


for idx,issue in enumerate(dupeIssues):
    print(f'\nDuplicates Left: {len(dupeIssues) - idx}')

    while True:
        try:
            issueTitle = issue['Title']
            issueProject = issue['Project']
            issueDescription = issue['Description']

            print("============")
            print(f'{issueTitle} in {issueProject}')
            print(f'\n{issueDescription}\n')

            options = input("""
                Enter the number of the option you wish to take:
                1. Mark as N/A in repositories
                2. Designate central repository for issue, mark all others as duplicates
                3. Skip this one
            """)
            optionsDic = {
                "1": markNotApplicable,
                "2": markDuplicates,
                "3": skip
            }
            optionsDic[options]()

        except KeyboardInterrupt:
            exit()
        except:
            print("===ERROR===")
            continue

        break
