import matplotlib.pyplot as plt
import random as rand
import numpy as np

OD = 0.001

DEATH_PENALTY = 1.5

mod_bullets_per_array = 0
mod_spin_speed = 1
mod_fire_rate = 1
mod_bullet_speed = 0
n_bullets = 0

def calculate_diff(no_hit_time, grazed_bullets):
	global OD
	global n_bullets
	core_action_points = 0

	no_hit_points = 0
	graze_points = 0
	
	# Points gained from not getting hit, considering time and amount of
	# bullets on screen
	no_hit_points = ((no_hit_time) * n_bullets ) / 20000
	graze_points = grazed_bullets * ((OD + 1)** 0.42)

	core_action_points = no_hit_points + graze_points
	
	accumulated_diff = core_action_points / 2
	OD += accumulated_diff

	generator_diff(OD)
	od = OD
	return OD




def generator_diff(overall_diff):
	global mod_bullets_per_array
	global mod_spin_speed
	global mod_fire_rate
	global mod_bullet_speed
	
	if overall_diff > 1:
		mod_bullet_speed = (overall_diff ** 0.0503) - 1
		if overall_diff < 200:
			mod_bullet_speed = mod_bullet_speed / ((200/overall_diff)**0.7)
		mod_spin_speed = 1
		mod_fire_rate = np.log10(overall_diff) / 2
		if mod_fire_rate <= 1:
			mod_fire_rate = 1
		# mod_fire_rate = (overall_diff ** 1/30)
		
		# if overall_diff > 10:
	
	if overall_diff < 300:
		mod_bullets_per_array = 0
	
	else:
		mod_bullets_per_array = 1

def prob_of_die():
	global OD
	if OD < 3:
		return 0.05
	elif OD < 10:
		return 0.1
	elif OD < 15:
		return 0.2/2
	elif OD < 25:
		return 0.4/2
	elif OD < 35:
		return 0.55/2
	elif OD < 50:
		return 0.55/2
	elif OD < 70:
		return 0.7/2
	elif OD < 90:
		return 0.85/2

def main():
	ods = []
	speeds = []
	for od in range(1,10000):
		ods.append(od)
		speeds.append(np.log10(od))
	
	



	for n in [200,200,200,200]:
		no_hit_time = 0
		last_hit = 0
		OD = 0.001
		i += 1
		ODs = []
		rODs = []
		mod_bullets_per_array_plt = []
		mod_spin_speed_plt = []
		mod_fire_rate_plt = []
		mod_bullet_speed_plt = []
		grazes = []
		tim = []
		grazetim = []
		n_bullets = n + rand.randrange(-30,30)
		for t in np.arange(0, MAX_TIME, 0.5):
			no_hit_time = t - last_hit
			tim.append(t)
			graze = 0

			r = rand.random()
			if r > 0.75 ** (100/n) and i >= 2:
				graze = 1
				grazes.append(1)
				grazetim.append(t)

			r = rand.random()
			
			# print(1/(OD+0.1))
			if CONSIDER_DEATH and r > 1 - prob_of_die():
				last_hit = t
				OD /= DEATH_PENALTY
			diff = calculate_diff(no_hit_time, graze)
			ODs.append(diff)
			# rODs.append(rOD)

			# plot generators
			generator_diff(OD)
			mod_bullets_per_array_plt.append(mod_bullets_per_array)
			mod_spin_speed_plt.append(mod_spin_speed)
			mod_fire_rate_plt.append(mod_fire_rate)
			mod_bullet_speed_plt.append(mod_bullet_speed)

		# MAKES PLOTS
			
		plt.subplot(411)
		plt.grid(True)
		plt.ylabel('overall_difficulty')
		plt.xlabel('time')
		plt.plot(tim,ODs, colors[i-1] )

		plt.subplot(412)
		plt.grid(True)
		plt.ylabel('mod_bullets_per_array')
		plt.xlabel('time')
		plt.plot(tim,mod_bullets_per_array_plt, colors[i-1] )

		# plt.subplot(513)
		# plt.grid(True)
		# plt.ylabel('mod_spin_speed')
		# plt.xlabel('time')
		# plt.plot(tim,mod_spin_speed_plt, colors[i-1] )

		plt.subplot(413)
		plt.grid(True)
		plt.ylabel('mod_fire_rate')
		plt.xlabel('time')
		plt.plot(tim,mod_fire_rate_plt, colors[i-1] )

		plt.subplot(414)
		plt.grid(True)
		plt.ylabel('mod_bullet_speed')
		plt.xlabel('time')
		plt.plot(tim,mod_bullet_speed_plt, colors[i-1] )

		# plt.subplot(616)
		# plt.grid(True)
		# plt.ylabel('grazes')
		# plt.xlabel('time')
		# plt.legend([str(sum(grazes)) + colors[i-1][0]] )
		# plt.plot(grazetim,grazes, colors[i-1][0]+'o' )
		# plt.plot(tim,rODs, colors[i-1] )
	print(colors[0][0])
	plt.suptitle('quero morrer')
	plt.show()

main()