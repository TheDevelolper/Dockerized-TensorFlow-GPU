import tensorflow as tf
import numpy as np

LOGDIR = "logs/tensorboard"

# OR Function - Sample data.

features = np.array([
    [0, 0], 
    [0, 1], 
    [1, 0], 
    [1, 1] 
], dtype=np.float32)

labels = np.array([
    [1, 0], # 0) first input = 0
    [0, 1], # 1) second input = 1
    [0, 1], # 1) also 1
    [1, 0]  # 0) also 0
], dtype=np.float32)

x = tf.placeholder(tf.float32, [1, 2], name="inputs")
y = tf.placeholder(tf.float32, [1, 2], name="labels")

# TODO REPLACE WITH:
# tf.random_uniform([2,2], -1, 1)

h1W = tf.Variable(np.random.uniform(low= -1, high= 1, size=(2, 3)), dtype=tf.float32, name="layer_1_weights")
h1b = tf.Variable(np.random.uniform(low= -1, high= 1, size=(1, 3)), dtype=tf.float32, name="layer_1_bias")
h1_wx_plus_b = tf.matmul(x, h1W) + h1b

h1_output = tf.nn.relu(h1_wx_plus_b)

h2x = h1_output
h2W = tf.Variable(np.random.uniform(low= -1, high= 1, size=(3, 4)), dtype=tf.float32, name="layer_2_weights")
h2b = tf.Variable(np.random.uniform(low= -1, high= 1, size=(1, 4)), dtype=tf.float32, name="layer_2_bias")
h2_wx_plus_b = tf.matmul(h1_output, h2W) + h2b
h2_output = tf.nn.relu(h2_wx_plus_b)

olx = h2_output
olW = tf.Variable(np.random.uniform(low= -1, high= 1, size=(4, 2)), dtype=tf.float32, name="output_weights")
olb = tf.Variable(np.random.uniform(low= -1, high= 1, size=(1, 2)), dtype=tf.float32, name="output_bias")

ol_wx_plus_b = tf.matmul(olx, olW) + olb

with tf.name_scope("accuracy"):
    # loss & softmax at the same time (for efficiency)
    y_estimated = tf.nn.softmax(ol_wx_plus_b)

    losses = tf.nn.softmax_cross_entropy_with_logits_v2(
    labels=y,
    logits=y_estimated)

    tf.summary.scalar("prediction loss", tf.math.reduce_mean(losses))

summ = tf.summary.merge_all()

variables_to_update = [h1W, h1b, h2W, h2b, olW, olb]

learning_rate = 0.01

train_step = tf.train.AdamOptimizer(learning_rate, name='Optimizer').minimize(losses, var_list = variables_to_update)
 
train_epocs = 4000000

all_losses = []

losses_for_all_epocs = []

correct_predictions_over_time = []

stop = False
writer = tf.summary.FileWriter(LOGDIR)
device = "/job:localhost/replica:0/task:0/device:XLA_GPU:0"
with tf.device(device):
    with tf.Session() as sess:

        sess.run(tf.global_variables_initializer())
        writer.add_graph(sess.graph)
        # Train the model.

        for i in range(train_epocs):
            
            if(stop):
                break
            
            for j in range(len(features)):

                if(stop):
                    break
                
                input_data = features[[j],:] # =~ [features[i]]
                label = labels[[j],:]

                feed_dict = { 

                    x:input_data,
                    y:label
                }
            
                currentLoss, _y_estimated, _, s = sess.run([losses, y_estimated, train_step, summ], feed_dict)
                
                writer.add_summary(s, i)
                all_losses.extend(currentLoss)
                
                current_loss = sum(all_losses)
                losses_for_all_epocs.append(current_loss)
                all_losses = []
            
        # Predict!
        for j in range(len(features)):
            
            input_data = features[[j],:] # =~ [features[i]]
            label = labels[[j],:]

            feed_dict = { 
                x:input_data,
                y:label
            }
            
            currentLoss, _y_estimated, _ = sess.run([losses, y_estimated, train_step], feed_dict)

            prediction = 0 if _y_estimated[0][0] > _y_estimated[0][1] else 1
            actual = 0 if label[0][0] > label[0][1] else 1
            
            print("For {} prediction: {} actual {}".format(input_data, prediction, actual))
            
        writer.add_graph(sess.graph)
        