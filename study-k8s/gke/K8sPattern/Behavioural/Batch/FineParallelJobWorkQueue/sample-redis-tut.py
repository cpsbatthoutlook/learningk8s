import redis

## https://redis.io/docs/management/
## https://redis-py.readthedocs.io/en/stable/commands.html#redis.commands.core.CoreCommands.lpos
## https://github.com/aio-libs-abandoned/aioredis-py/tree/master/docs/examples
## https://redis.io/commands/lrange/

redis_host='redis'
redis_port=6379

def redis_string():
    try:
        r = redis.StrictRedis(host=redis_host, port=redis_port, decode_responses=True)
        r.set('message', 'hello world')
        msg = r.get('message')
        print(msg)
    except Exception as e:
        print(e)
        
def redis_int(no):
    try:
        r = redis.StrictRedis(host=redis_host, port=redis_port, decode_responses=True)
        r.set('number', no)
        o_number = r.get('number')
        r.incr('number')
        inc_no = r.get('number')
        print(o_number)
        print(inc_no)
    except Exception as e:
        print(e)
        
def redis_multi():
r.lpush('foo', *[1,2,3,4,5,6,7,8,9])
r.lpush('foo', 'test1')
popped_item = r.lpop('mylist')
print(popped_item)
