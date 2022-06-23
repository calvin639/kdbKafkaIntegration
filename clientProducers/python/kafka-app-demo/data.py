from faker import Faker
from random import choice as rand
fake = Faker()
#Sensor data Example
sids=('voltage', 'temp', 'pressure', 'spice')
vals=[[1.2,1.25,1.26,1.27,1.23,1.4],[30, 31, 32, 33, 34, 35, 36, 37, 38],[.05, .06, .07, .08, .09, .085, .075, .065],[1, 2, 3]]
inds=range(len(sids))

def create_sData():
    i=rand(inds)
    s=sids[i]
    v=rand(vals[i])
    return {
        'sensor': s,
        'reading': v,
    }

#Original Example
def get_registered_user():
    return {
        'name': fake.name(),
        'address': fake.address(),
        'created_at': fake.year()
    }

if __name__ == '__main__':
    print("sData created")
    #print(get_registered_user())